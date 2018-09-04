//
//  SelectAddressViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 10/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift
import CoreLocation

class SearchDeputyByAddressViewModel: BaseViewModel {
    
    var searchPlaceText = PublishSubject<String>()
    var searchPlaceResultsViewModels = PublishSubject<[PlaceViewModel]>()
    var isErrorViewDisplayed = Variable<Bool>(false)
    var isLoadingViewDisplayed = Variable<Bool>(false)
    var didClearSearchText = PublishSubject<Void>()
    var enterAddressPlaceholder = R.string.localizable.enter_address()
    
    private var api: Api
    
    required init(api: Api) {
        
        self.api = api
        super.init()
        
        self.configure()
        
    }
    
    // MARK: - Configuration
    
    private func configure() {
        
        self.didChangeSearchPlaceText()
            .subscribe(onNext: { [weak self] _ in
                self?.isLoadingViewDisplayed.value = true
                self?.searchPlaceResultsViewModels.onNext([])
            }).disposed(by: self.disposeBag)

        self.didChangeSearchPlaceText()
            .flatMapLatest { [weak self] searchString -> Observable<[PlaceViewModel]> in

                if let cachedPlaces = CacheManager.sharedInstance.getData(forKey: searchString) as? [Place], cachedPlaces.count > 0 {
                    return self?.placesViewModels(fromCache: cachedPlaces, forSearchString: searchString) ?? Observable<[PlaceViewModel]>.empty()
                } else {
                    return self?.placesViewModelsFromWebService(forSearchString: searchString).catchErrorJustReturn([]) ?? Observable<[PlaceViewModel]>.empty()
                }

            }
            .subscribe(onNext: { [weak self] placesViewModels in
                self?.searchPlaceResultsViewModels.onNext(placesViewModels)
                self?.isLoadingViewDisplayed.value = false
                self?.isErrorViewDisplayed.value = placesViewModels.count > 0 ? false : true
            }).disposed(by: self.disposeBag)
        

        self.didClearSearchText.subscribe(onNext: { [weak self] _ in
            self?.searchPlaceResultsViewModels.onNext([])
            self?.isLoadingViewDisplayed.value = false
            self?.isErrorViewDisplayed.value = false
        }).disposed(by: self.disposeBag)
        
    }
    
    // MARK: - Helpers
    
    private func didChangeSearchPlaceText() -> Observable<String> {
        return self.searchPlaceText
            .distinctUntilChanged()
            .filter({ searchString in
                searchString.count > 3
            })
    }
    
    private func placesViewModels(fromCache cachedPlaces: [Place], forSearchString searchString:String) -> Observable<[PlaceViewModel]> {
        log.debug("\(cachedPlaces.count) results found from cache")
        let placesViewModels = self.getPlacesViewModels(from: cachedPlaces)
        return Observable.of(placesViewModels)
    }
    
    private func placesViewModelsFromWebService(forSearchString searchString:String) -> Observable<[PlaceViewModel]> {
        
        return Observable<[PlaceViewModel]>.create({ [unowned self] observer in
            
            log.debug("Search : '\(searchString)'")
            
            let disposable = self.api.places(forText: searchString).subscribe(onNext: { [unowned self] places in
                
                log.debug("\(places.count) results found")
                
                guard places.count > 0 else {
                    observer.onError(DAError(message: R.string.localizable.error_no_address_found()))
                    return
                }

                CacheManager.sharedInstance.update(data: places as AnyObject, forKey: searchString)
                let placesViewModels = self.getPlacesViewModels(from: places)

                observer.onNext(placesViewModels)
                observer.onCompleted()
                
            }, onError: { error in
                log.error("Autocomplete query error : \(error)")
                observer.onError(DAError(error:error, message: R.string.localizable.error_address_search()))
            })
            
            return Disposables.create([disposable])
        })
    }
    
    private func getPlacesViewModels(from places: [Place]) -> [PlaceViewModel] {
        
        var placesViewModels = [PlaceViewModel]()
        
        for place in places {
            let placeViewModel = PlaceViewModel(place: place)
            placesViewModels.append(placeViewModel)
        }
        
        return placesViewModels
    }
    
}
