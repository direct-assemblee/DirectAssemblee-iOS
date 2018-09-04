//
//  WelcomeOnboardingViewModelTests.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 10/07/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest

@testable import direct_assemblee

class WelcomeOnboardingViewModelTests: BaseTests {
    
    func testViewModelShouldBeCorrectlyFilled() {

        let viewModel = WelcomeOnboardingViewModel()
        
        XCTAssert(viewModel.welcomeText.value == R.string.localizable.onboarding_welcome())
        XCTAssert(viewModel.useGeolocationText.value == R.string.localizable.onboarding_use_geolocation())
        XCTAssert(viewModel.enterAddressText.value == R.string.localizable.onboarding_enter_address())
        XCTAssert(viewModel.addressDisclaimerText.value == R.string.localizable.onboarding_address_disclaimer())
        
    }
    
    
}
