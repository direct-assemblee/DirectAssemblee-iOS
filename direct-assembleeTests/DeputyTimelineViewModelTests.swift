//
//  DeputyTimelineViewModelTests.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 14/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest
import RxSwift
import RxBlocking

@testable import direct_assemblee

class DeputyTimelineViewModelTests: BaseTests {
    
    //MARK: - Display
    
    func testViewModelAtInitShouldBeOk() {
        
        let deputyTimelineViewModel = DeputyTimelineViewModel()
        
        XCTAssert(deputyTimelineViewModel.noEventsPlaceholderText == "")
        XCTAssert(deputyTimelineViewModel.isEventsListHidden.value == true)
        XCTAssert(deputyTimelineViewModel.isPlaceholderViewHidden.value == true)
        XCTAssert(deputyTimelineViewModel.isLoadingViewDisplayed.value == true)
        XCTAssert(deputyTimelineViewModel.isPullToRefreshControlDisplayed.value == false)
        XCTAssert(deputyTimelineViewModel.reloadText.value == R.string.localizable.reload())
    }
    
    func testViewModelWithLoadingShouldBeOk() {
        
        let deputyTimelineViewModel = DeputyTimelineViewModel()
        deputyTimelineViewModel.displayLoading()
    
        XCTAssert(deputyTimelineViewModel.noEventsPlaceholderText == "")
        XCTAssert(deputyTimelineViewModel.isEventsListHidden.value == true)
        XCTAssert(deputyTimelineViewModel.isPlaceholderViewHidden.value == true)
        XCTAssert(deputyTimelineViewModel.isLoadingViewDisplayed.value == true)
        XCTAssert(deputyTimelineViewModel.isPullToRefreshControlDisplayed.value == false)
    }
    
    func testViewModelWithErrorShouldBeOk() {
        
        let deputyTimelineViewModel = DeputyTimelineViewModel()
        let eventsViewModelsAsyncExpectation = expectation(description: "eventsViewModels")
        
        var retrievedTimelineEventsViewModels = [TimelineEventViewModel]()
        
        deputyTimelineViewModel.eventsViewModels.subscribe(onNext: { eventsViewModels in
            retrievedTimelineEventsViewModels = eventsViewModels
            eventsViewModelsAsyncExpectation.fulfill()
        }).disposed(by: self.disposeBag)
        
        deputyTimelineViewModel.displayError(error: DAError(message: R.string.localizable.error_timeline_events()))
        
        self.waitForExpectations(timeout: 1) { error in
            XCTAssert(retrievedTimelineEventsViewModels.count == 0)
            XCTAssert(deputyTimelineViewModel.noEventsPlaceholderText == R.string.localizable.error_timeline_events())
            XCTAssert(deputyTimelineViewModel.isEventsListHidden.value == true)
            XCTAssert(deputyTimelineViewModel.isPlaceholderViewHidden.value == false)
            XCTAssert(deputyTimelineViewModel.isLoadingViewDisplayed.value == false)
            XCTAssert(deputyTimelineViewModel.isPullToRefreshControlDisplayed.value == false)
        }
    }

    func testViewModelWithEventsShouldBeOk() {
        
        let deputyTimelineViewModel = DeputyTimelineViewModel()
        let events = [TimelineEvent(id: 1, type: .commission, date: Date(), title: "title1"), TimelineEvent(id: 1, type: .commission, date: Date(), title: "title2")]
        let eventsViewModelsAsyncExpectation = expectation(description: "eventsViewModels")
        
        var retrievedTimelineEventsViewModels = [TimelineEventViewModel]()
        
        deputyTimelineViewModel.eventsViewModels.subscribe(onNext: { eventsViewModels in
            retrievedTimelineEventsViewModels = eventsViewModels
            eventsViewModelsAsyncExpectation.fulfill()
        }).disposed(by: self.disposeBag)
        
        deputyTimelineViewModel.displayEvents(timelineEvents: events)
        
        self.waitForExpectations(timeout: 1) { error in
            XCTAssert(retrievedTimelineEventsViewModels.count == 2)
            XCTAssert(deputyTimelineViewModel.noEventsPlaceholderText == "")
            XCTAssert(deputyTimelineViewModel.isEventsListHidden.value == false)
            XCTAssert(deputyTimelineViewModel.isPlaceholderViewHidden.value == true)
            XCTAssert(deputyTimelineViewModel.isLoadingViewDisplayed.value == false)
            XCTAssert(deputyTimelineViewModel.isPullToRefreshControlDisplayed.value == false)
        }
    }
    
    func testEventSelectionShouldReturnTimelineEventsViewerViewModel() {
        
        let deputyTimelineViewModel = DeputyTimelineViewModel()
        let timelineEvent1 = self.testsHelper.timelineEvent(withId: 1)
        let timelineEvent2 = self.testsHelper.timelineEvent(withId: 2)
        let timelineEvent2ViewModel = TimelineEventViewModel(timelineEvent: timelineEvent2)
        let events = [timelineEvent1, timelineEvent2]
        let eventsViewModelsAsyncExpectation = expectation(description: "eventsViewModels")
        
        deputyTimelineViewModel.eventsViewModels.subscribe(onNext: { eventsViewModels in
            deputyTimelineViewModel.selectedTimelineEventViewModel.onNext(timelineEvent2ViewModel)
            eventsViewModelsAsyncExpectation.fulfill()
        }).disposed(by: self.disposeBag)
        
        deputyTimelineViewModel.displayEvents(timelineEvents: events)

        self.waitForExpectations(timeout: 1) { error in
            XCTAssert(deputyTimelineViewModel.timelineEventsViewerViewModelToDisplay.value != nil)
            XCTAssert(deputyTimelineViewModel.timelineEventsViewerViewModelToDisplay.value?.eventsDetailsViewModelsList.value.count == 2)
            XCTAssert(deputyTimelineViewModel.timelineEventsViewerViewModelToDisplay.value?.displayedEventIndex.value == 1)
            XCTAssert(deputyTimelineViewModel.timelineEventsViewerViewModelToDisplay.value?.numberOfEvents == 2)
        }
    }
    
    
    func testDisplayedEventInEventsViewerShouldScrollListAtThisEvent() {
        
        let deputyTimelineViewModel = DeputyTimelineViewModel()
        let timelineEvent1 = self.testsHelper.timelineEvent()
        let timelineEvent2 = self.testsHelper.timelineEvent()
        let timelineEvent1ViewModel = TimelineEventViewModel(timelineEvent: timelineEvent1)
        let events = [timelineEvent1, timelineEvent2]
        let eventsViewModelsAsyncExpectation = expectation(description: "eventsViewModels")
        
        deputyTimelineViewModel.eventsViewModels.subscribe(onNext: { eventsViewModels in
            deputyTimelineViewModel.selectedTimelineEventViewModel.onNext(timelineEvent1ViewModel)
            deputyTimelineViewModel.timelineEventsViewerViewModelToDisplay.value?.displayedEventIndex.value = 1
            eventsViewModelsAsyncExpectation.fulfill()
        }).disposed(by: self.disposeBag)
        
        deputyTimelineViewModel.displayEvents(timelineEvents: events)
        
        self.waitForExpectations(timeout: 1) { error in
            deputyTimelineViewModel.eventIndexToScroll.subscribe(onNext: { index in
                XCTAssert(index == 1)
            }).disposed(by: self.disposeBag)
        }
    }
    
    //MARK: - Refresh and infinite scroll
    
    func testViewModelShouldBeOkWithPullToRefresh() {
        
        let testExpectation = expectation(description: "expectation")
        
        self.testsHelper.saveDeputy()
        
        let deputyMainViewModel = DeputyMainViewModel(api: self.testsHelper.timelineApi, database: self.testsHelper.database)
        let deputyFloatingHeaderViewModel = try! deputyMainViewModel.childViewModel.observeOn(MainScheduler.instance).toBlocking().first()!
        let timelineViewModel = deputyFloatingHeaderViewModel.contentViewModel as! DeputyTimelineViewModel
        
        var retrievedEvents = [TimelineEventViewModel]()
        timelineViewModel.isPullToRefreshControlDisplayed.value = true
        
        timelineViewModel.eventsViewModels.asObservable().subscribe(onNext: { eventsViewModels in
            retrievedEvents = eventsViewModels
            testExpectation.fulfill()
        }).disposed(by: self.disposeBag)

        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedEvents.count == 15)
            XCTAssert(timelineViewModel.isPullToRefreshControlDisplayed.value == false)
        }
    }
    
    func testViewModelShouldBeOkWithUserWantToLoadData() {
        
        let testExpectation = expectation(description: "expectation")
        
        self.testsHelper.saveDeputy()
        
        let deputyMainViewModel = DeputyMainViewModel(api: self.testsHelper.timelineApi, database: self.testsHelper.database)
        let deputyFloatingHeaderViewModel = try! deputyMainViewModel.childViewModel.observeOn(MainScheduler.instance).toBlocking().first()!
        let timelineViewModel = deputyFloatingHeaderViewModel.contentViewModel as! DeputyTimelineViewModel
        
        var retrievedEvents = [TimelineEventViewModel]()
        timelineViewModel.isUserWantsToLoadAll.onNext(())
        
        timelineViewModel.eventsViewModels.asObservable().subscribe(onNext: { eventsViewModels in
            retrievedEvents = eventsViewModels
            testExpectation.fulfill()
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedEvents.count == 15)
        }
    }
    
    
    func testViewModelShouldBeOkWithInfiniteScroll() {
        
        let testExpectation = expectation(description: "expectation")
        
        self.testsHelper.saveDeputy()
        
        let deputyMainViewModel = DeputyMainViewModel(api: self.testsHelper.timelineApi, database: self.testsHelper.database)
        let deputyFloatingHeaderViewModel = try! deputyMainViewModel.childViewModel.observeOn(MainScheduler.instance).toBlocking().first()!
        let timelineViewModel = deputyFloatingHeaderViewModel.contentViewModel as! DeputyTimelineViewModel
        deputyMainViewModel.loadAll()
        
        var retrievedEvents = [TimelineEventViewModel]()
        var numberOfCalls = 0
        
        timelineViewModel.isReadyToLoadMoreEvents.value = true
        
        timelineViewModel.eventsViewModels.asObservable().subscribe(onNext: { eventsViewModels in
            retrievedEvents = eventsViewModels
            numberOfCalls = numberOfCalls + 1
            
            if (numberOfCalls == 2) {
                testExpectation.fulfill()
            }
            
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedEvents.count == 30)
            XCTAssert(timelineViewModel.isReadyToLoadMoreEvents.value == false)
        }
    }
    
}
