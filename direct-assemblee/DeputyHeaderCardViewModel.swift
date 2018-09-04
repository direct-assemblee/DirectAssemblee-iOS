//
//  DeputyHeaderCardViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 05/07/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift
import FirebaseMessaging
import RealmSwift

class DeputyHeaderCardViewModel: BaseViewModel {
    
    private var api:Api
    private var database:Realm
    private var deputy:Deputy!
    private var deputyMode = DeputyMode.follow
    
    var completeNameText = Variable<String>("")
    var districtText = Variable<String>("")
    var parliamentGroupText = Variable<String>("")
    var activityRateText = Variable<String>("")
    var activityRateTitleText = Variable<String>(R.string.localizable.deputy_details_activityRate())
    var photoData = Variable<Data>(Data())
    
    var isInformationButtonHidden = Variable<Bool>(false)
    var isReducedInformationButtonViewHidden = Variable<Bool>(false)
    var isReducedPhotoViewHidden = Variable<Bool>(false)
    var isBackButtonHidden = Variable<Bool>(true)
    var isCloseButtonHidden = Variable<Bool>(false)
    var isProfileAvailable = Variable<Bool>(true)
    var isActivityHidden = Variable<Bool>(false)
    
    var didTapOnReducedHeader = PublishSubject<Void>()
    var didTapOnDisplayDeputyProfile = PublishSubject<Void>()
    var deputyProfileViewModelToDisplay = PublishSubject<DeputyFloatingHeaderViewModel>()
    
    init(api:Api, database:Realm, deputyMode: DeputyMode = .follow) {
        
        self.api = api
        self.database = database
        self.deputyMode = deputyMode
        
        super.init()
        
        self.configureUserActions()
    }
    
    func display(deputy:Deputy, headerMode:HeaderMode = .master) {
        
        self.deputy = deputy
        
        if let activityRate = deputy.activityRate.value {
            self.activityRateText.value = "\(activityRate) %"
        } else {
            self.activityRateText.value = "-- %"
        }
        
        self.completeNameText.value = "\(deputy.firstName) \(deputy.lastName)"
        self.parliamentGroupText.value = deputy.parliamentGroup ?? ""
        
        if let districtNumber = deputy.districtNumber.value {
            let districtNumberSuffix = districtNumber == 1 ? R.string.localizable.district_first(districtNumber) : R.string.localizable.district_others(districtNumber)
            self.districtText.value = "\(R.string.localizable.district(districtNumberSuffix)) - \(deputy.department?.name ?? "")"
        }
        
        if let photoData = deputy.photoData {
            self.photoData.value = photoData
        }

        if headerMode == .master {
            self.configureForMasterMode()
        } else if headerMode == .detail {
            self.configureForDetailMode()
        }
    }
    
    func disableDeputyProfileAccess() {
        self.isProfileAvailable.value = false
        self.isInformationButtonHidden.value = true
        self.isReducedInformationButtonViewHidden.value = true
    }
    
    func enableDeputyProfileAccess() {
        self.isProfileAvailable.value = true
        self.isInformationButtonHidden.value = false
        self.isReducedInformationButtonViewHidden.value = false
    }
    
    //MARK: - Configure
    
    private func configureUserActions() {
        
        self.didTapOnDisplayDeputyProfile.subscribe(onNext: { [unowned self] _ in
            
            let deputyFloatingHeaderViewModelForDetail = DeputyFloatingHeaderViewModel(deputy: self.deputy,
                                                                                       contentViewModel: DeputyDetailsViewModel(deputy: self.deputy),
                                                                                       api: self.api,
                                                                                       database: self.database,
                                                                                       headerMode: HeaderMode.detail,
                                                                                       deputyMode: self.deputyMode)
            
            self.deputyProfileViewModelToDisplay.onNext(deputyFloatingHeaderViewModelForDetail)
            self.sendTagForEvent("display_deputy_profile")
            
        }).disposed(by: self.disposeBag)
        
    }
    
    private func configureForMasterMode() {
        
        self.isReducedPhotoViewHidden.value = false
        self.isBackButtonHidden.value = true
        self.isCloseButtonHidden.value = (self.deputyMode == .follow)
        self.isReducedInformationButtonViewHidden.value = false
        self.isInformationButtonHidden.value = false
        self.isProfileAvailable.value = true
        self.isActivityHidden.value = false
    
    }
    
    private func configureForDetailMode() {
        
        self.isReducedPhotoViewHidden.value = true
        self.isBackButtonHidden.value = false
        self.isCloseButtonHidden.value = true
        self.isReducedInformationButtonViewHidden.value = true
        self.isInformationButtonHidden.value = true
        self.isProfileAvailable.value = false
        self.isActivityHidden.value = true
    }

    //MARK: - Tagging
    
    private func sendTagForEvent(_ event: String) {
        TaggageManager.sendEvent(eventName: event, forDeputy: self.deputy)
    }
    
    
}
