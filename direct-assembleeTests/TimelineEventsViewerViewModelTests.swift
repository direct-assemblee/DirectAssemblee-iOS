//
//  BallotDetailsViewModelTests.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 28/07/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest

@testable import direct_assemblee

class TimelineEventsViewerViewModelTests: BaseTests {
    
    func testViewModelShouldBeFilledWithModelCorrectly() {
        
        let timelineEvent1 = self.testsHelper.timelineEvent(withId: 1, withType: .question)
        let timelineEvent2 = self.testsHelper.timelineEvent(withId: 2)
        let timelineEvent3 = self.testsHelper.timelineEvent(withId: 3)
        let timelineEvents = [timelineEvent1, timelineEvent2, timelineEvent3]
        let timelineEventsViewerViewModel = TimelineEventsViewerViewModel(events: timelineEvents, displayedEvent: timelineEvent2)
        
        XCTAssert(timelineEventsViewerViewModel.eventsDetailsViewModelsList.value[0] is NonBallotViewModel == true)
        XCTAssert(timelineEventsViewerViewModel.eventsDetailsViewModelsList.value[1] is BallotViewModel == true)
        XCTAssert(timelineEventsViewerViewModel.eventsDetailsViewModelsList.value[2] is BallotViewModel == true)
        XCTAssert(timelineEventsViewerViewModel.displayedEventIndex.value == 1)
        XCTAssert(timelineEventsViewerViewModel.numberOfEvents == 3)
        XCTAssert(timelineEventsViewerViewModel.themeText.value == "Pouvoirs publics et Constitution")
        XCTAssert(timelineEventsViewerViewModel.titleText.value == "Evènement")
    }
    
    func testViewModelShouldBeFilledWithModelWithFullNameCorrectly() {
        
        let timelineEvent1 = self.testsHelper.timelineEvent(
            withUserDeputyVoteResult: .agree,
            withTheme: TimelineEventTheme(
                type: .job,
                defaultName: "Travail",
                fullName: "Ordonnances prises sur le fondement de la loi sur le renforcement du dialogue social",
                shortName: nil))
        
        let timelineEvents = [timelineEvent1]
        let timelineEventsViewerViewModel = TimelineEventsViewerViewModel(events: timelineEvents, displayedEvent: timelineEvent1)
        
        XCTAssert(timelineEventsViewerViewModel.themeText.value == "Ordonnances prises sur le fondement de la loi sur le renforcement du dialogue social")
    }
    
    func testViewModelShouldBeFilledWithModelWithShortNameCorrectly() {
        
        let timelineEvent1 = self.testsHelper.timelineEvent(
            withUserDeputyVoteResult: .agree,
            withTheme: TimelineEventTheme(
                type: .job,
                defaultName: "Travail",
                fullName: "Ordonnances prises sur le fondement de la loi sur le renforcement du dialogue social",
                shortName: "Ordonnances sur le renforcement du dialogue social"))
        
        let timelineEvents = [timelineEvent1]
        let timelineEventsViewerViewModel = TimelineEventsViewerViewModel(events: timelineEvents, displayedEvent: timelineEvent1)
        
        XCTAssert(timelineEventsViewerViewModel.themeText.value == "Ordonnances sur le renforcement du dialogue social")
    }
    
    func testViewModelShouldBeUpdatedWhenEventChanges() {
        
        let timelineEvent1 = self.testsHelper.timelineEvent(withId: 1, withType: .question)
        let timelineEvent2 = self.testsHelper.timelineEvent(withId: 2)
        let timelineEvent3 = self.testsHelper.timelineEvent(withId: 3, withTitle:"Test", withTheme: TimelineEventTheme(type: .agriculture, defaultName: "Agriculture", fullName: nil, shortName: nil))
        let timelineEvents = [timelineEvent1, timelineEvent2, timelineEvent3]
        let timelineEventsViewerViewModel = TimelineEventsViewerViewModel(events: timelineEvents, displayedEvent: timelineEvent2)
        timelineEventsViewerViewModel.displayedEventIndex.value = 2
        
        XCTAssert(timelineEventsViewerViewModel.themeText.value == "Agriculture")
        XCTAssert(timelineEventsViewerViewModel.titleText.value == "Test")
    }
}
