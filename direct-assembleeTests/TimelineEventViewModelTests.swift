//
//  TimelineEventViewModelTests.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 07/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest

@testable import direct_assemblee

class TimelineEventViewModelTests: BaseTests {

    func testViewModelShouldBeCorrectlyFilledWithNonVoteEvent() {
        
        var timelineEvent = TimelineEvent(id: 1, type: .lawProposal, date: Date.from(string: "07/06/2017")!, title: "proposition de loi")
        timelineEvent.description = "proposition pour se déplacer en fusée"
        timelineEvent.theme = self.testsHelper.timelineEventTheme()
        
        let timelineEventViewModel = TimelineEventViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(timelineEventViewModel.dateText.value == "07/06/2017")
        XCTAssert(timelineEventViewModel.titleText.value == "proposition de loi")
        XCTAssert(timelineEventViewModel.descriptionText.value == "proposition pour se déplacer en fusée")
        XCTAssert(timelineEventViewModel.isAdoptedStatusColorCode == Constants.Color.grayColorCode)
        XCTAssert(timelineEventViewModel.isVoteEvent == false)
        XCTAssert(timelineEventViewModel.themeImageName.value == "ic_pouvoirs_publics")
        XCTAssert(timelineEventViewModel.themeText.value == "Pouvoirs publics et Constitution")
        
    }
    
    func testViewModelShouldBeCorrectlyFilledWithAdoptedOrdinaryVoteEventWithDeputyAgreeResult() {
        
        let timelineEvent = self.testsHelper.timelineEvent(withUserDeputyVoteResult: .agree)
        let timelineEventViewModel = TimelineEventViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(timelineEventViewModel.titleText.value == "Evènement")
        XCTAssert(timelineEventViewModel.descriptionText.value == "description")
        XCTAssert(timelineEventViewModel.isVoteEvent == true)
        XCTAssert(timelineEventViewModel.isAdoptedStatusColorCode == Constants.Color.greenColorCode)
        XCTAssert(timelineEventViewModel.isAdoptedText.value == R.string.localizable.timeline_ballot_adopted().uppercased())
        XCTAssert(timelineEventViewModel.userDeputyVoteColorCode == Constants.Color.greenColorCode)
        XCTAssert(timelineEventViewModel.userDeputyVoteResultImageName == R.image.icon_deputy.name)
        XCTAssert(timelineEventViewModel.userDeputyVoteResultText.value == R.string.localizable.vote_result_for().uppercased())
        XCTAssert(timelineEventViewModel.themeImageName.value == "ic_pouvoirs_publics")
        XCTAssert(timelineEventViewModel.themeText.value == "Pouvoirs publics et Constitution")
        
    }
    
    func testViewModelShouldBeCorrectlyFilledWithNotAdoptedOrdinaryVoteEventWithDeputyAgainstResult() {
        
        let timelineEvent = self.testsHelper.timelineEvent(withUserDeputyVoteResult: .against, isAdopted: false)
        let timelineEventViewModel = TimelineEventViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(timelineEventViewModel.isAdoptedStatusColorCode == Constants.Color.redColorCode)
        XCTAssert(timelineEventViewModel.isAdoptedText.value == R.string.localizable.timeline_ballot_not_adopted().uppercased())
        XCTAssert(timelineEventViewModel.userDeputyVoteColorCode == Constants.Color.redColorCode)
        XCTAssert(timelineEventViewModel.userDeputyVoteResultImageName == R.image.icon_deputy.name)
        XCTAssert(timelineEventViewModel.userDeputyVoteResultText.value == R.string.localizable.vote_result_against().uppercased())
        XCTAssert(timelineEventViewModel.themeImageName.value == "ic_pouvoirs_publics")
        XCTAssert(timelineEventViewModel.themeText.value == "Pouvoirs publics et Constitution")
        
    }
    
    func testViewModelShouldBeCorrectlyFilledWithAdoptedForMotionOfCensureWithDeputySignedResult() {
        
        let timelineEvent = self.testsHelper.timelineEvent(withType: .motionOfCensureVote, withUserDeputyVoteResult: .signed)
        let timelineEventViewModel = TimelineEventViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(timelineEventViewModel.isAdoptedStatusColorCode == Constants.Color.greenColorCode)
        XCTAssert(timelineEventViewModel.isAdoptedText.value == R.string.localizable.timeline_motion_of_censure_adopted().uppercased())
        XCTAssert(timelineEventViewModel.userDeputyVoteColorCode == Constants.Color.greenColorCode)
        XCTAssert(timelineEventViewModel.userDeputyVoteResultImageName == R.image.icon_deputy.name)
        XCTAssert(timelineEventViewModel.userDeputyVoteResultText.value == R.string.localizable.timeline_event_motion_of_censure_signed().uppercased())
        XCTAssert(timelineEventViewModel.themeImageName.value == "ic_pouvoirs_publics")
        XCTAssert(timelineEventViewModel.themeText.value == "Pouvoirs publics et Constitution")
        
    }
    
    func testViewModelShouldBeCorrectlyFilledWithNotAdoptedForMotionOfCensureWithDeputyNotSignedResult() {
        
        let timelineEvent = self.testsHelper.timelineEvent(withType: .motionOfCensureVote, withUserDeputyVoteResult: .notSigned, isAdopted: false)
        let timelineEventViewModel = TimelineEventViewModel(timelineEvent: timelineEvent)

        XCTAssert(timelineEventViewModel.isAdoptedStatusColorCode == Constants.Color.redColorCode)
        XCTAssert(timelineEventViewModel.isAdoptedText.value == R.string.localizable.timeline_motion_of_censure_not_adopted().uppercased())
        XCTAssert(timelineEventViewModel.userDeputyVoteColorCode == Constants.Color.redColorCode)
        XCTAssert(timelineEventViewModel.userDeputyVoteResultImageName == R.image.icon_deputy.name)
        XCTAssert(timelineEventViewModel.userDeputyVoteResultText.value == R.string.localizable.timeline_event_motion_of_censure_not_signed().uppercased())
        XCTAssert(timelineEventViewModel.themeImageName.value == "ic_pouvoirs_publics")
        XCTAssert(timelineEventViewModel.themeText.value == "Pouvoirs publics et Constitution")
        
    }
   
    func testViewModelShouldBeCorrectlyFilledWithOrdinaryVoteEventWithDeputyMissingResult() {
        
        let timelineEvent = self.testsHelper.timelineEvent(withUserDeputyVoteResult: .missing)
        let timelineEventViewModel = TimelineEventViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(timelineEventViewModel.userDeputyVoteResultImageName == R.image.icon_missing_deputy.name)
        XCTAssert(timelineEventViewModel.userDeputyVoteColorCode == Constants.Color.orangeColorCode)
        XCTAssert(timelineEventViewModel.userDeputyVoteResultText.value == R.string.localizable.vote_result_missing().uppercased())
        XCTAssert(timelineEventViewModel.themeImageName.value == "ic_pouvoirs_publics")
        XCTAssert(timelineEventViewModel.themeText.value == "Pouvoirs publics et Constitution")
        
    }
    
    func testViewModelShouldBeCorrectlyFilledWithOrdinaryVoteEventWithDeputyNonVotingResult() {
        
        let timelineEvent = self.testsHelper.timelineEvent(withUserDeputyVoteResult: .nonVoting)
        let timelineEventViewModel = TimelineEventViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(timelineEventViewModel.userDeputyVoteResultImageName == R.image.icon_deputy.name)
        XCTAssert(timelineEventViewModel.userDeputyVoteColorCode == Constants.Color.yellowColorCode)
        XCTAssert(timelineEventViewModel.userDeputyVoteResultText.value == R.string.localizable.vote_result_non_voting().uppercased())
        XCTAssert(timelineEventViewModel.themeImageName.value == "ic_pouvoirs_publics")
        XCTAssert(timelineEventViewModel.themeText.value == "Pouvoirs publics et Constitution")
        
    }
    
    func testViewModelShouldBeCorrectlyFilledWithOrdinaryVoteEventWithDeputyBlankResult() {
        
        let timelineEvent = self.testsHelper.timelineEvent(withUserDeputyVoteResult: .blank)
        let timelineEventViewModel = TimelineEventViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(timelineEventViewModel.userDeputyVoteResultImageName == R.image.icon_deputy.name)
        XCTAssert(timelineEventViewModel.userDeputyVoteColorCode == Constants.Color.grayColorCode)
        XCTAssert(timelineEventViewModel.userDeputyVoteResultText.value == R.string.localizable.vote_result_blank().uppercased())
        XCTAssert(timelineEventViewModel.themeImageName.value == "ic_pouvoirs_publics")
        XCTAssert(timelineEventViewModel.themeText.value == "Pouvoirs publics et Constitution")
        
    }
    
    func testViewModelShouldBeCorrectlyFilledWithFullName() {
        
        let timelineEvent = self.testsHelper.timelineEvent(
            withUserDeputyVoteResult: .blank,
            withTheme: TimelineEventTheme(
                type: .job,
                defaultName: "Travail",
                fullName:"Ordonnances prises sur le fondement de la loi sur le renforcement du dialogue social",
                shortName: nil))
        
        let timelineEventViewModel = TimelineEventViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(timelineEventViewModel.themeImageName.value == "ic_travail")
        XCTAssert(timelineEventViewModel.themeText.value == "Ordonnances prises sur le fondement de la loi sur le renforcement du dialogue social")
        
    }
    
    func testViewModelShouldBeCorrectlyFilledWithShortName() {
        
        let timelineEvent = self.testsHelper.timelineEvent(
            withUserDeputyVoteResult: .blank,
            withTheme: TimelineEventTheme(
                type: .job,
                defaultName: "Travail",
                fullName: "Ordonnances prises sur le fondement de la loi sur le renforcement du dialogue social",
                shortName: "Ordonnances sur le renforcement du dialogue social"))
        
        let timelineEventViewModel = TimelineEventViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(timelineEventViewModel.themeImageName.value == "ic_travail")
        XCTAssert(timelineEventViewModel.themeText.value == "Ordonnances sur le renforcement du dialogue social")
        
    }
    
    
    
    
}
