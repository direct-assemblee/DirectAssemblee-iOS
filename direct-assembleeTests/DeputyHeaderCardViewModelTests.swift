//
//  deputyHeaderCardViewModelTests.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 05/07/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest

@testable import direct_assemblee

class DeputyHeaderCardViewModelTests: BaseTests {
    
    override func setUp() {
        super.setUp()
        
        self.testsHelper.saveDeputy()
    }
    
    //MARK: - Deputy display
    
    func testViewModelShoulDisplayDeputyCorrectlyInMasterModeForFollow() {
        
        let deputy = self.getDeputy()
        deputy.districtNumber.value = 1
        let deputyHeaderCardViewModel = DeputyHeaderCardViewModel(api:self.testsHelper.emptyApi, database:self.testsHelper.database, deputyMode: .follow)
        deputyHeaderCardViewModel.display(deputy: deputy, headerMode: HeaderMode.master)
        
        XCTAssert(deputyHeaderCardViewModel.completeNameText.value == "Jean-Michel Député")
        XCTAssert(deputyHeaderCardViewModel.districtText.value == "1ère circonscription - Hérault")
        XCTAssert(deputyHeaderCardViewModel.parliamentGroupText.value == "La France insoumise")
        XCTAssert(deputyHeaderCardViewModel.activityRateTitleText.value == R.string.localizable.deputy_details_activityRate())
        XCTAssert(deputyHeaderCardViewModel.activityRateText.value == "95 %")
        XCTAssert(deputyHeaderCardViewModel.photoData.value == Data())
        
        XCTAssert(deputyHeaderCardViewModel.isInformationButtonHidden.value == false)
        XCTAssert(deputyHeaderCardViewModel.isReducedInformationButtonViewHidden.value == false)
        XCTAssert(deputyHeaderCardViewModel.isReducedPhotoViewHidden.value == false)
        XCTAssert(deputyHeaderCardViewModel.isBackButtonHidden.value == true)
        XCTAssert(deputyHeaderCardViewModel.isCloseButtonHidden.value == true)
        XCTAssert(deputyHeaderCardViewModel.isProfileAvailable.value == true)
    }
    
    func testViewModelShoulDisplayDeputyCorrectlyInMasterModeForConsult() {
        
        let deputy = self.getDeputy()
        deputy.districtNumber.value = 1
        let deputyHeaderCardViewModel = DeputyHeaderCardViewModel(api:self.testsHelper.emptyApi, database:self.testsHelper.database, deputyMode: .consult)
        deputyHeaderCardViewModel.display(deputy: deputy, headerMode: HeaderMode.master)
        
        XCTAssert(deputyHeaderCardViewModel.completeNameText.value == "Jean-Michel Député")
        XCTAssert(deputyHeaderCardViewModel.districtText.value == "1ère circonscription - Hérault")
        XCTAssert(deputyHeaderCardViewModel.parliamentGroupText.value == "La France insoumise")
        XCTAssert(deputyHeaderCardViewModel.activityRateTitleText.value == R.string.localizable.deputy_details_activityRate())
        XCTAssert(deputyHeaderCardViewModel.activityRateText.value == "95 %")
        XCTAssert(deputyHeaderCardViewModel.photoData.value == Data())
        
        XCTAssert(deputyHeaderCardViewModel.isInformationButtonHidden.value == false)
        XCTAssert(deputyHeaderCardViewModel.isReducedInformationButtonViewHidden.value == false)
        XCTAssert(deputyHeaderCardViewModel.isReducedPhotoViewHidden.value == false)
        XCTAssert(deputyHeaderCardViewModel.isBackButtonHidden.value == true)
        XCTAssert(deputyHeaderCardViewModel.isCloseButtonHidden.value == false)
        XCTAssert(deputyHeaderCardViewModel.isProfileAvailable.value == true)
    }
    
    
    func testViewModelShouldDisplayDeputyCorrectlyInDetailModeForFollow() {
        
        let deputy = self.getDeputy()
        let deputyHeaderCardViewModel = DeputyHeaderCardViewModel(api:self.testsHelper.emptyApi, database:self.testsHelper.database, deputyMode: .follow)
        deputyHeaderCardViewModel.display(deputy: deputy, headerMode: HeaderMode.detail)
        
        XCTAssert(deputyHeaderCardViewModel.completeNameText.value == "Jean-Michel Député")
        XCTAssert(deputyHeaderCardViewModel.districtText.value == "2ème circonscription - Hérault")
        XCTAssert(deputyHeaderCardViewModel.parliamentGroupText.value == "La France insoumise")
        XCTAssert(deputyHeaderCardViewModel.activityRateTitleText.value == R.string.localizable.deputy_details_activityRate())
        XCTAssert(deputyHeaderCardViewModel.activityRateText.value == "95 %")
        XCTAssert(deputyHeaderCardViewModel.photoData.value == Data())
        
        XCTAssert(deputyHeaderCardViewModel.isInformationButtonHidden.value == true)
        XCTAssert(deputyHeaderCardViewModel.isReducedInformationButtonViewHidden.value == true)
        XCTAssert(deputyHeaderCardViewModel.isReducedPhotoViewHidden.value == true)
        XCTAssert(deputyHeaderCardViewModel.isBackButtonHidden.value == false)
        XCTAssert(deputyHeaderCardViewModel.isCloseButtonHidden.value == true)
        XCTAssert(deputyHeaderCardViewModel.isProfileAvailable.value == false)
    }
    
    func testViewModelShouldDisplayDeputyCorrectlyInDetailModeForConsult() {
        
        let deputy = self.getDeputy()
        let deputyHeaderCardViewModel = DeputyHeaderCardViewModel(api:self.testsHelper.emptyApi, database:self.testsHelper.database, deputyMode: .consult)
        deputyHeaderCardViewModel.display(deputy: deputy, headerMode: HeaderMode.detail)
        
        XCTAssert(deputyHeaderCardViewModel.completeNameText.value == "Jean-Michel Député")
        XCTAssert(deputyHeaderCardViewModel.districtText.value == "2ème circonscription - Hérault")
        XCTAssert(deputyHeaderCardViewModel.parliamentGroupText.value == "La France insoumise")
        XCTAssert(deputyHeaderCardViewModel.activityRateTitleText.value == R.string.localizable.deputy_details_activityRate())
        XCTAssert(deputyHeaderCardViewModel.activityRateText.value == "95 %")
        XCTAssert(deputyHeaderCardViewModel.photoData.value == Data())
        
        XCTAssert(deputyHeaderCardViewModel.isInformationButtonHidden.value == true)
        XCTAssert(deputyHeaderCardViewModel.isReducedInformationButtonViewHidden.value == true)
        XCTAssert(deputyHeaderCardViewModel.isReducedPhotoViewHidden.value == true)
        XCTAssert(deputyHeaderCardViewModel.isBackButtonHidden.value == false)
        XCTAssert(deputyHeaderCardViewModel.isCloseButtonHidden.value == true)
        XCTAssert(deputyHeaderCardViewModel.isProfileAvailable.value == false)
    }
    
    func testViewModelShouldDisplayDeputyCorrectlyWithoutActivityRate() {
        
        let deputyHeaderCardViewModel = DeputyHeaderCardViewModel(api:self.testsHelper.emptyApi, database:self.testsHelper.database)
        deputyHeaderCardViewModel.display(deputy: self.testsHelper.deputy())
        
        XCTAssert(deputyHeaderCardViewModel.activityRateTitleText.value == R.string.localizable.deputy_details_activityRate())
        XCTAssert(deputyHeaderCardViewModel.activityRateText.value == "-- %")
    }
    
    func testViewModelShouldDisplayDeputyCorrectlyWithoutPhoto() {
        
        let deputyHeaderCardViewModel = DeputyHeaderCardViewModel(api:self.testsHelper.emptyApi, database:self.testsHelper.database)
        deputyHeaderCardViewModel.display(deputy: self.testsHelper.deputy())

        XCTAssert(deputyHeaderCardViewModel.photoData.value == Data())
    }

    // MARK: - Display profile
    
    func testViewModelShouldProvideCorrectViewModelToDisplayWhenUserTapOnDisplayProfile() {
        
        let testExpectation = expectation(description: "expectation")
        
        let deputyHeaderCardViewModel = DeputyHeaderCardViewModel(api:self.testsHelper.emptyApi, database:self.testsHelper.database)
        deputyHeaderCardViewModel.display(deputy: self.testsHelper.deputy(), headerMode: HeaderMode.master)
        
        var viewModel:DeputyFloatingHeaderViewModel?
        
        deputyHeaderCardViewModel.deputyProfileViewModelToDisplay.subscribe(onNext: { providedViewModel in
            viewModel = providedViewModel
            testExpectation.fulfill()
        }).disposed(by: self.disposeBag)
        
        deputyHeaderCardViewModel.didTapOnDisplayDeputyProfile.onNext(())
        
        self.waitForExpectations(timeout: 1) { error in
            XCTAssert(viewModel?.contentViewModel is DeputyDetailsViewModel)
        }
        
    }
    
    func testViewModelShouldBeOkIfProfileAccessIfEnabled() {
        
        let deputyHeaderCardViewModel = DeputyHeaderCardViewModel(api:self.testsHelper.emptyApi, database:self.testsHelper.database)
        deputyHeaderCardViewModel.display(deputy: self.testsHelper.deputy(), headerMode: HeaderMode.master)
        deputyHeaderCardViewModel.enableDeputyProfileAccess()
        
        XCTAssert(deputyHeaderCardViewModel.isProfileAvailable.value == true)
    }
    
    func testViewModelShouldBeOkIfProfileAccessIfDisabled() {
        
        let deputyHeaderCardViewModel = DeputyHeaderCardViewModel(api:self.testsHelper.emptyApi, database:self.testsHelper.database)
        deputyHeaderCardViewModel.display(deputy: self.testsHelper.deputy(), headerMode: HeaderMode.master)
        deputyHeaderCardViewModel.disableDeputyProfileAccess()
        
        XCTAssert(deputyHeaderCardViewModel.isProfileAvailable.value == false)
    }

    
    //MARK: - Private helpers
    
    private func getDeputy() -> Deputy {
        
        let deputy = self.testsHelper.deputy()
        
        deputy.parliamentGroup = "La France insoumise"
        deputy.job = "Vendeur de glaces"
        deputy.photoUrl = "http://www.jeanmichel-images.org/depute.jpg"
        deputy.parliamentAgeInMonths.value = 5
        deputy.commission = "Affaires culturelles et éducation"
        deputy.activityRate.value = 95
        deputy.photoData = Data()
        
        return deputy
    }
    
}
