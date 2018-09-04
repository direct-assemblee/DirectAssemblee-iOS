//
//  WelcomeOnboardingViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 10/07/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift

enum EnterAddressFeatureState {
    case enabled
    case disabled(message: String)
}

class WelcomeOnboardingViewModel: BaseViewModel {
    
    var welcomeText:Variable<String>
    var useGeolocationText:Variable<String>
    var enterAddressText:Variable<String>
    var useAllDeputiesList:Variable<String>
    var addressDisclaimerText:Variable<String>
    
    var enterAddressFeatureState = PublishSubject<EnterAddressFeatureState>()
    
    override init() {
        self.welcomeText = Variable<String>(R.string.localizable.onboarding_welcome())
        self.useGeolocationText = Variable<String>(R.string.localizable.onboarding_use_geolocation())
        self.useAllDeputiesList = Variable<String>(R.string.localizable.onboarding_use_all_deputies_list())
        self.enterAddressText = Variable<String>(R.string.localizable.onboarding_enter_address())
        self.addressDisclaimerText = Variable<String>(R.string.localizable.onboarding_address_disclaimer())
        
        super.init()
    }
    
}
