//
//  NonBallotViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 10/08/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift

class NonBallotViewModel: BaseViewModel {
    
    private var timelineEvent: TimelineEvent
    
    var infosViewModels = Variable<[NonBallotInfoViewModel]>([])
    var readMoreText = Variable<String>(R.string.localizable.read_more())
    var readMoreUrl:URL?
    var didTapOnReadMore = PublishSubject<Void>()
    
    init(timelineEvent: TimelineEvent) {
        
        self.timelineEvent = timelineEvent
        
        super.init()
        
        self.configure()
    }
    
    //MARK: - Configure
    
    private func configure() {
        
        self.readMoreUrl = URL(string:self.timelineEvent.fileUrl ?? "")
        
        if [.lawProposal, .cosignedLawProposal].contains(self.timelineEvent.type) {
            self.infosViewModels.value = self.getInfosViewModelsForLawProposal()
        } else if self.timelineEvent.type == .commission {
            self.infosViewModels.value = self.getInfosViewModelsForCommission()
        } else {
            self.infosViewModels.value = self.getInfosViewModelsForAllEvents()
        }
        
        self.configureDidTapOnReadMore()
    }
    
    private func configureDidTapOnReadMore() {
        
        self.didTapOnReadMore.subscribe(onNext: { [weak self] _ in
            self?.sendTagEventForReadMore()
        }).disposed(by: self.disposeBag)
    }
    
    private func getInfosViewModelsForLawProposal() -> [NonBallotInfoViewModel] {
        
        var infos = self.getInfosViewModelsForAllEvents()
        
        if self.timelineEvent.extraInfo.count == 1,
            let lawMotives = self.timelineEvent.extraInfo[Constants.TimelineEventExtraInfoKey.lawMotives] as? String {
            
            let lawMotivesInfos = [
                NonBallotInfoViewModel(key: Constants.TimelineEventExtraInfoKey.lawMotivesTitle, value: R.string.localizable.law_motives()),
                NonBallotInfoViewModel(key: Constants.TimelineEventExtraInfoKey.lawMotivesText, value: lawMotives)
            ]
            
            infos.append(contentsOf: lawMotivesInfos)
        }
        
        return infos
    }
    
    private func getInfosViewModelsForCommission() -> [NonBallotInfoViewModel] {
        
        var infos = self.getInfosViewModelsForAllEvents()
        
        if self.timelineEvent.extraInfo.count == 2,
            let commissionName = self.timelineEvent.extraInfo[Constants.TimelineEventExtraInfoKey.commissionName] as? String ,
            let commissionTime = self.timelineEvent.extraInfo[Constants.TimelineEventExtraInfoKey.commissionTime] as? String {
            
            infos.insert(NonBallotInfoViewModel(key: Constants.TimelineEventExtraInfoKey.commissionTime, value: commissionTime), at: 1)
            infos.insert(NonBallotInfoViewModel(key: Constants.TimelineEventExtraInfoKey.commissionName, value: commissionName), at: 2)
        }
        
        return infos
    }
    
    private func getInfosViewModelsForAllEvents() -> [NonBallotInfoViewModel] {
        
        return [
            NonBallotInfoViewModel(key: Constants.TimelineEventExtraInfoKey.date, value: self.getDateText()),
            NonBallotInfoViewModel(key: Constants.TimelineEventExtraInfoKey.description, value: self.timelineEvent.description)
        ]
    }
    
    
    //MARK: - Private helpers
    
    private func getDateText() -> String {
        return self.timelineEvent.date.toString(withFormat: "EEEE d MMMM yyyy", withLocale: "fr").capitalized
    }
    
    //MARK: - Tagging
    
    private func sendTagEventForReadMore() {
        TaggageManager.sendEvent(eventName: "display_more_timeline_event", forTimelineEvent:self.timelineEvent)
    }
    
}
