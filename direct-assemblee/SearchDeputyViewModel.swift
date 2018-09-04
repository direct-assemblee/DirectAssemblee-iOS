//
//  SearchDeputyViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 06/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift
import RxCocoa
import CoreLocation
import RealmSwift
import FirebaseMessaging

class SearchDeputyViewModel: BaseViewModel, OnboardingFinalStepViewModel {
    
    private var api:Api
    private var database:Realm
    private var locationManager:CLLocationManager?
    private var userCoordinates = Observable<CLLocationCoordinate2D?>.empty()
    
    var multipleDeputyFoundViewModel = PublishSubject<MultipleDeputiesFoundViewModel>()
    var processingText = BehaviorSubject<String>(value: R.string.localizable.onboarding_search_deputy())
    var isLoadingViewHidden = Variable<Bool>(false)
    var didSelectDeputy = PublishSubject<SelectDeputyStatus>()
    
    init(api:Api, database:Realm, userCoordinates:CLLocationCoordinate2D?) {
        
        self.api = api
        self.database = database
        
        super.init()
        
        if let userCoordinates = userCoordinates {
            self.userCoordinates = Observable<CLLocationCoordinate2D?>.from(optional: userCoordinates)
        } else {
            self.locationManager = CLLocationManager()
            self.userCoordinates = self.userLocationCoordinatesObservable()
            self.configureGeolocationError()
        }
        
        self.configureSearchDeputy()
        
    }
    
    // MARK: - Configuration
    
    private func configureSearchDeputy() {
        
        self.searchDeputyObservable().subscribe(onNext: { [unowned self] deputies in
            
            if deputies.count > 1 {
                let multipleDeputiesFoundViewModel = MultipleDeputiesFoundViewModel(api:self.api, database:self.database, deputies: deputies)
                self.multipleDeputyFoundViewModel.onNext(multipleDeputiesFoundViewModel)
                TaggageManager.sendEvent(eventName: "multiple_deputies_found", parameters: ["number" : deputies.count as NSObject])
                
            } else if deputies.count == 1 {
                self.finishOnboardingForSingleDeputyFound(deputies[0])
            }
            
            }, onError: { [weak self] error in
                self?.processingText.onNext(String(describing: error))
                self?.isLoadingViewHidden.value = true
        }).disposed(by: self.disposeBag)
    }
    
    private func configureGeolocationError() {
        
        guard let locationManager = self.locationManager else {
            return
        }
        
        locationManager.rx.didFailWithError.subscribe(onNext: { [weak self] error in
            log.error("Geolocation error : \(error)")
            self?.processingText.onNext(R.string.localizable.error_geolocation())
            self?.isLoadingViewHidden.value = true
        }).disposed(by: self.disposeBag)
        
        
        locationManager.rx.didChangeAuthorizationStatus.subscribe(onNext: { [weak self] status in
            
            guard status == .restricted || status == .denied else {
                return
            }
            
            log.error("Geolocation status : \(status)")
            self?.processingText.onNext(R.string.localizable.onboarding_disabled_geolocation())
            self?.processingText.onCompleted()
            self?.isLoadingViewHidden.value = true
            
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: - Helpers
    
    private func searchDeputyObservable() -> Observable<[DeputySummary]> {
        
        return self.userCoordinates
            .flatMap { [weak self] userCoordinates -> Observable<[DeputySummary]> in
                
                guard let userCoordinates = userCoordinates else {
                    return Observable<[DeputySummary]>.empty()
                }
                
                return self?.api.deputies(
                    forLatitude: userCoordinates.latitude,
                    andLongitude: userCoordinates.longitude) ?? Observable<[DeputySummary]>.empty()
                
            }.flatMap({ deputies -> Observable<[DeputySummary]> in
                
                guard deputies.count > 0 else  {
                    log.error("0 deputy found")
                    return Observable.error(DAError(message:R.string.localizable.deputy_not_found()))
                }
                
                log.debug("\(deputies.count) deputies found")
                
                return Observable.of(deputies)
            })
    }
    
    
    private func userLocationCoordinatesObservable() -> Observable<CLLocationCoordinate2D?> {
        
        guard let locationManager = self.locationManager else {
            return Observable<CLLocationCoordinate2D?>.empty()
        }
        
        let startLocationObservable = Observable<CLLocationCoordinate2D?>.create { observer in
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            observer.onCompleted()
            return Disposables.create()
        }
        
        let userLocationObservable = locationManager.rx
            .didUpdateLocations
            .take(1)
            .map { locations -> CLLocationCoordinate2D? in
                return locations.count > 0 ? locations[0].coordinate : nil
        }
        
        let stopLocationObservable = Observable<CLLocationCoordinate2D?>.create { observer in
            locationManager.stopUpdatingLocation()
            observer.onCompleted()
            return Disposables.create()
        }
        
        return Observable.of(startLocationObservable, userLocationObservable, stopLocationObservable).concat()
    }
    
    
    private func finishOnboardingForSingleDeputyFound(_ deputy: DeputySummary) {
        
        self.api.downloadImage(url: deputy.photoUrl ?? "").subscribe(onNext: { [weak self] data in
            deputy.photoData = data
            self?.saveAndFinishOnboardingForDeputy(deputy)
        }).disposed(by: self.disposeBag)
    }
    
    private func saveAndFinishOnboardingForDeputy(_ deputy: DeputySummary) {
        
        self.finishOnboarding(deputy: deputy, api: self.api, database: self.database).subscribe(onNext: { [weak self] in
            self?.didSelectDeputy.onNext(SelectDeputyStatus.followStarts)
        }, onError: { [weak self] error in
            self?.processingText.onNext(R.string.localizable.error_deputies_list())
            self?.isLoadingViewHidden.value = true
        }).disposed(by: self.disposeBag)

    }

}
