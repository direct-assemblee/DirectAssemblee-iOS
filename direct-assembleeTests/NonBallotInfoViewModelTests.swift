//
//  NonBallotInfoViewModelTests.swift
//  direct-assembleeTests
//
//  Created by COUDSI Julien on 07/10/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest

@testable import direct_assemblee

class NonBallotInfoViewModelTests: BaseTests {
    
    func testViewModelShouldBeFilledCorrectlyForDateInfo() {
        
        let nonBallotInfoViewModel = NonBallotInfoViewModel(key:Constants.TimelineEventExtraInfoKey.date, value:"Samedi 7 Octobre 2017")
        
        XCTAssert(nonBallotInfoViewModel.textValue.value == "Samedi 7 Octobre 2017")
        XCTAssert(nonBallotInfoViewModel.textSize.value == 14)
        XCTAssert(nonBallotInfoViewModel.isBold.value == true)
        XCTAssert(nonBallotInfoViewModel.isCentered.value == true)
    }
    
    func testViewModelShouldBeFilledCorrectlyForLawMotivesInfo() {
        
        let nonBallotInfoViewModel = NonBallotInfoViewModel(key:Constants.TimelineEventExtraInfoKey.lawMotivesTitle, value:R.string.localizable.law_motives())
        
        XCTAssert(nonBallotInfoViewModel.textValue.value == R.string.localizable.law_motives())
        XCTAssert(nonBallotInfoViewModel.textSize.value == 14)
        XCTAssert(nonBallotInfoViewModel.isBold.value == true)
        XCTAssert(nonBallotInfoViewModel.isCentered.value == true)
    }
    
    func testViewModelShouldBeFilledCorrectlyForCommissionTimeInfo() {
        
        let nonBallotInfoViewModel = NonBallotInfoViewModel(key:Constants.TimelineEventExtraInfoKey.commissionTime, value:"Séance de 9 heures 30")
        
        XCTAssert(nonBallotInfoViewModel.textValue.value == "Séance de 9 heures 30")
        XCTAssert(nonBallotInfoViewModel.textSize.value == 14)
        XCTAssert(nonBallotInfoViewModel.isBold.value == true)
        XCTAssert(nonBallotInfoViewModel.isCentered.value == true)
    }
    
    func testViewModelShouldBeFilledCorrectlyForCommissionNameInfo() {
        
        let nonBallotInfoViewModel = NonBallotInfoViewModel(key:Constants.TimelineEventExtraInfoKey.commissionName, value:"Commission de la cordialité")
        
        XCTAssert(nonBallotInfoViewModel.textValue.value == "Commission de la cordialité")
        XCTAssert(nonBallotInfoViewModel.textSize.value == 14)
        XCTAssert(nonBallotInfoViewModel.isBold.value == true)
        XCTAssert(nonBallotInfoViewModel.isCentered.value == true)
    }
    
    func testViewModelShouldBeFilledCorrectlyForOtherInfo() {
        
        let nonBallotInfoViewModel = NonBallotInfoViewModel(key:Constants.TimelineEventExtraInfoKey.description, value:"blop")
        XCTAssert(nonBallotInfoViewModel.textValue.value == "blop")
        XCTAssert(nonBallotInfoViewModel.textSize.value == 14)
        XCTAssert(nonBallotInfoViewModel.isBold.value == false)
        XCTAssert(nonBallotInfoViewModel.isCentered.value == false)
    }
    
}

