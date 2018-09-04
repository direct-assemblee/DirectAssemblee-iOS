//
//  DeputyTimelineViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 14/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift

class DeputyTimelineViewModel: BaseViewModel, FloatingHeaderContentViewModel {
    
    private var timelineEvents = [TimelineEvent]()
    private var timelineEventsViewModels = [TimelineEventViewModel]()
    
    var eventsViewModels = PublishSubject<[TimelineEventViewModel]>()
    var noEventsPlaceholderText = ""
    var isEventsListHidden = Variable<Bool>(false)
    var isPlaceholderViewHidden = Variable<Bool>(false)
    var isLoadingViewDisplayed = Variable<Bool>(true)
    var isPullToRefreshControlDisplayed = Variable<Bool>(false)
    var isUserWantsToLoadAll = PublishSubject<Void>()
    var isReadyToLoadMoreEvents = Variable<Bool>(false)
    var areTotalEventsLoaded = Variable<Bool>(false)
    var isLoadMoreEventsFinished = Variable<Bool>(false)
    var eventIndexToScroll = PublishSubject<Int>()
    var listScrollOffset = PublishSubject<CGFloat>()
    var didUserWantToScrollToTop = PublishSubject<Void>()
    var reloadText = Variable<String>(R.string.localizable.reload())
    
    var peekedIndexPath = PublishSubject<IndexPath>()
    var selectedTimelineEventViewModel = PublishSubject<TimelineEventViewModel>()
    var timelineEventsViewerViewModelToDisplay = Variable<TimelineEventsViewerViewModel?>(nil)
    var timelineEventsViewerViewModelToPeek = Variable<TimelineEventsViewerViewModel?>(nil)
    
    override init() {
        super.init()
        
        self.displayLoading()
        self.configureOpenTimelineEventsViewer()
        self.configurePeekAndPop()
    }
    
    // MARK: - Configure
    
    func displayLoading() {
        
        self.isEventsListHidden.value = true
        self.isPlaceholderViewHidden.value = true
        self.isLoadingViewDisplayed.value = true
        self.isPullToRefreshControlDisplayed.value = false
        self.noEventsPlaceholderText = ""
    }
    
    func displayEvents(timelineEvents:[TimelineEvent]) {
        
        var timelineEventsViewModels = [TimelineEventViewModel]()
        
        for timelineEvent in timelineEvents {
            timelineEventsViewModels.append(TimelineEventViewModel(timelineEvent: timelineEvent))
        }
        
        self.isLoadingViewDisplayed.value = false
        self.isPullToRefreshControlDisplayed.value = false
        
        if timelineEventsViewModels.count > 0 {
            self.configureForEvents()
        } else {
            self.configureForNoEvents()
        }
        
        self.timelineEvents = timelineEvents
        self.timelineEventsViewModels = timelineEventsViewModels
        self.eventsViewModels.onNext(timelineEventsViewModels)
        self.handleBallotIdReceivedFromNotificationIfExists()
    }
    
    func displayError(error:DAError) {
        
        self.eventsViewModels.onNext([])
        self.noEventsPlaceholderText = String(describing: error)
        self.isEventsListHidden.value = true
        self.isPlaceholderViewHidden.value = false
        self.isLoadingViewDisplayed.value = false
        self.isPullToRefreshControlDisplayed.value = false
    }
    
    // MARK: - Events from notifications
    
    private func handleBallotIdReceivedFromNotificationIfExists() {
        
        if let eventIdFromNotification =  NotificationsManager.sharedInstance.eventIdFromNotification,
            let timelineEventViewModel = self.getTimelineEventViewModelFromEventId(eventIdFromNotification) {
            
            log.debug("Ballot received from a notification found : \(eventIdFromNotification)")
            self.selectedTimelineEventViewModel.onNext(timelineEventViewModel)
            NotificationsManager.sharedInstance.eventIdFromNotification = nil
        }
    }
    
    private func getTimelineEventViewModelFromEventId(_ eventId:Int) -> TimelineEventViewModel? {
        
        guard let timelineEventIndex = self.timelineEvents.index(where: { timelineEvent in
            return timelineEvent.id == eventId
        }) else {
            return nil
        }
        
        return TimelineEventViewModel(timelineEvent: self.timelineEvents[timelineEventIndex])
    }
    
    // MARK: - Private helpers
    
    private func configureForEvents() {
        self.noEventsPlaceholderText = ""
        self.isEventsListHidden.value = false
        self.isPlaceholderViewHidden.value = true
    }
    
    private func configureForNoEvents() {
        self.noEventsPlaceholderText = R.string.localizable.error_no_timeline_events()
        self.isEventsListHidden.value = true
        self.isPlaceholderViewHidden.value = false
    }
    
    private func configureOpenTimelineEventsViewer() {
        
        self.selectedTimelineEventViewModel.subscribe(onNext: { [weak self] timelineEventViewModel in
            
            TaggageManager.sendEvent(eventName: "display_timeline_event_detail", forTimelineEvent: timelineEventViewModel.timelineEvent)
            
            let timelineEventsViewerViewModel = TimelineEventsViewerViewModel(events: self?.timelineEvents ?? [], displayedEvent: timelineEventViewModel.timelineEvent)
            self?.timelineEventsViewerViewModelToDisplay.value = timelineEventsViewerViewModel
            self?.configureScrollListToDisplayedEvent()
        }).disposed(by: self.disposeBag)
    }
    
    private func configurePeekAndPop() {
        
        self.peekedIndexPath.subscribe(onNext: { [weak self] indexPath in
            
            guard let peekedEvent = self?.timelineEvents[indexPath.row] else {
                return
            }
            
            let timelineEventsViewerViewModel = TimelineEventsViewerViewModel(events: self?.timelineEvents ?? [], displayedEvent: peekedEvent)
            self?.timelineEventsViewerViewModelToPeek.value = timelineEventsViewerViewModel
            
        }).disposed(by: self.disposeBag)
    }
    
    private func configureScrollListToDisplayedEvent() {
        
        let timelineEventsViewerViewModel = self.timelineEventsViewerViewModelToDisplay.value
        
        timelineEventsViewerViewModel?.timelineIndexToScroll.subscribe(onNext: { [weak self] index in
            self?.eventIndexToScroll.onNext(index)
        }).disposed(by: self.disposeBag)
    }
    
    
}
