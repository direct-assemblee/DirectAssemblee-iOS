//
//  BallotViewerViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 28/07/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift

class TimelineEventsViewerViewModel: BaseViewModel {
    
    private var events = [TimelineEvent]()

    var timelineIndexToScroll = PublishSubject<Int>()
    var displayedEventIndex = Variable<Int>(0)
    var eventsDetailsViewModelsList = Variable<[BaseViewModel]>([])
    var themeText = Variable<String>("")
    var titleText = Variable<String>("")
    
    var numberOfEvents:Int {
        return eventsDetailsViewModelsList.value.count
    }
    
    init(events:[TimelineEvent], displayedEvent:TimelineEvent) {
        
        self.events = events
        self.displayedEventIndex.value = self.events.index(of: displayedEvent) ?? 0
        
        super.init()
        
        self.configure()
    }
    
    // MARK: - Configure
    
    private func configure() {
        
        self.configureHeader()
        self.configureTimelineEventsList()
    }
    
    private func configureTimelineEventsList() {
        
        var eventDetailsViewModels = [BaseViewModel]()
        
        for timelineEvent in self.events {
            eventDetailsViewModels.append(timelineEvent.voteInfo != nil ? BallotViewModel(timelineEvent: timelineEvent) : NonBallotViewModel(timelineEvent: timelineEvent))
        }
        
        self.eventsDetailsViewModelsList.value = eventDetailsViewModels
    }
    
    private func configureHeader() {
        
        self.displayedEventIndex.asObservable().subscribe(onNext: { [unowned self] eventIndex in
            self.themeText.value = self.events[eventIndex].theme.name
            self.titleText.value = self.events[eventIndex].title
        }).disposed(by: self.disposeBag)
        
    }
    
}
