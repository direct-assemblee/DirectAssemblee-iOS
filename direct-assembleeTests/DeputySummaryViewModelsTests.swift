//
//  DeputeViewModelTests.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 05/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest

@testable import direct_assemblee

class DeputySummaryViewModelsTests: BaseTests {

    func testViewModelShouldBeCorrectlyFilledWithModelAndPhotoData() {
        
        let deputySummary = self.testsHelper.deputySummary()
        
        deputySummary.parliamentGroup = "La France insoumise"
        deputySummary.photoUrl = "http://www.jeanmichel-images.org/depute.jpg"
        deputySummary.photoData = UIImagePNGRepresentation(UIImage(named: Constants.Image.deputyPhotoPlaceholderName)!)!
        
        let deputySummaryViewModel = DeputySummaryViewModel(deputy: deputySummary)
        
        XCTAssert(deputySummaryViewModel.completeNameText.value == "Jean-Michel Député")
        XCTAssert(deputySummaryViewModel.districtText.value == "2ème circonscription")
        XCTAssert(deputySummaryViewModel.departmentText.value == "Hérault")
        XCTAssert(deputySummaryViewModel.parliamentGroupText.value == "La France insoumise")
        XCTAssert(deputySummaryViewModel.photoData.value == UIImagePNGRepresentation(UIImage(named: Constants.Image.deputyPhotoPlaceholderName)!)!)
        XCTAssert(deputySummaryViewModel.photoUrl.value == "http://www.jeanmichel-images.org/depute.jpg")
    }
    
    func testViewModelShouldBeCorrectlyFilledWithModelWithoutPhotoData() {
        
        let deputySummary = self.testsHelper.deputySummary()
        
        let deputySummaryViewModel = DeputySummaryViewModel(deputy: deputySummary)
        
        XCTAssert(deputySummaryViewModel.photoData.value == Data())
    }

    
}
