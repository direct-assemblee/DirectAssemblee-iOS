//
//  NonBallotViewModelTests.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 10/08/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest

@testable import direct_assemblee

class NonBallotViewModelTests: BaseTests {
    
    func testViewModelShouldBeFilledCorrectlyWithEventWithoutExtraInfos() {
        
        var timelineEvent = self.testsHelper.timelineEvent(withType: .question)
        timelineEvent.description = "description"
        let nonBallotViewModel = NonBallotViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(nonBallotViewModel.infosViewModels.value.count == 2)
        XCTAssert(nonBallotViewModel.infosViewModels.value[0].textValue.value == "Mercredi 6 Septembre 2017")
        XCTAssert(nonBallotViewModel.infosViewModels.value[1].textValue.value == "description")
        XCTAssert(nonBallotViewModel.readMoreText.value == R.string.localizable.read_more())
    }
    
    func testViewModelShouldBeFilledCorrectlyWithLawProposalEvent() {
        
        var timelineEvent = self.testsHelper.timelineEvent(withType: .lawProposal)
        timelineEvent.description = "description"
        timelineEvent.extraInfo = [Constants.TimelineEventExtraInfoKey.lawMotives:"Cordialité"]
        
        let nonBallotViewModel = NonBallotViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(nonBallotViewModel.infosViewModels.value.count == 4)
        XCTAssert(nonBallotViewModel.infosViewModels.value[0].textValue.value  == "Mercredi 6 Septembre 2017")
        XCTAssert(nonBallotViewModel.infosViewModels.value[1].textValue.value  == "description")
        XCTAssert(nonBallotViewModel.infosViewModels.value[2].textValue.value  == R.string.localizable.law_motives())
        XCTAssert(nonBallotViewModel.infosViewModels.value[3].textValue.value  == "Cordialité")
    }
    
    func testViewModelShouldBeFilledCorrectlyWithCosignedLawProposalEvent() {
        
        var timelineEvent = self.testsHelper.timelineEvent(withType: .cosignedLawProposal)
        timelineEvent.description = "description"
        timelineEvent.extraInfo = [Constants.TimelineEventExtraInfoKey.lawMotives:"Cordialité"]
        
        let nonBallotViewModel = NonBallotViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(nonBallotViewModel.infosViewModels.value.count == 4)
        XCTAssert(nonBallotViewModel.infosViewModels.value[0].textValue.value  == "Mercredi 6 Septembre 2017")
        XCTAssert(nonBallotViewModel.infosViewModels.value[1].textValue.value  == "description")
        XCTAssert(nonBallotViewModel.infosViewModels.value[2].textValue.value  == R.string.localizable.law_motives())
        XCTAssert(nonBallotViewModel.infosViewModels.value[3].textValue.value  == "Cordialité")
    }
    
    func testViewModelShouldBeFilledCorrectlyWithCosignedLawProposalEventWithoutExtraInfo() {
        
        var timelineEvent = self.testsHelper.timelineEvent(withType: .cosignedLawProposal)
        timelineEvent.description = "description"

        let nonBallotViewModel = NonBallotViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(nonBallotViewModel.infosViewModels.value.count == 2)
        XCTAssert(nonBallotViewModel.infosViewModels.value[0].textValue.value  == "Mercredi 6 Septembre 2017")
        XCTAssert(nonBallotViewModel.infosViewModels.value[1].textValue.value  == "description")
    }
    
    func testViewModelShouldBeFilledCorrectlyWithCommissionEvent() {
        
        var timelineEvent = self.testsHelper.timelineEvent(withType: .commission)
        timelineEvent.description = "description"
        timelineEvent.extraInfo = [
            Constants.TimelineEventExtraInfoKey.commissionName:"Commission de la bienveillance",
            Constants.TimelineEventExtraInfoKey.commissionTime:"Séance de 9 heures 30"
        ]
        let nonBallotViewModel = NonBallotViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(nonBallotViewModel.infosViewModels.value.count == 4)
        XCTAssert(nonBallotViewModel.infosViewModels.value[0].textValue.value  == "Mercredi 6 Septembre 2017")
        XCTAssert(nonBallotViewModel.infosViewModels.value[1].textValue.value  == "Séance de 9 heures 30")
        XCTAssert(nonBallotViewModel.infosViewModels.value[2].textValue.value  == "Commission de la bienveillance")
        XCTAssert(nonBallotViewModel.infosViewModels.value[3].textValue.value  == "description")
    }
    
    func testViewModelShouldBeFilledCorrectlyWithCommissionEventWithoutExtraInfo() {
        
        var timelineEvent = self.testsHelper.timelineEvent(withType: .commission)
        timelineEvent.description = "description"
        let nonBallotViewModel = NonBallotViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(nonBallotViewModel.infosViewModels.value.count == 2)
        XCTAssert(nonBallotViewModel.infosViewModels.value[0].textValue.value  == "Mercredi 6 Septembre 2017")
        XCTAssert(nonBallotViewModel.infosViewModels.value[1].textValue.value  == "description")
    }

}
