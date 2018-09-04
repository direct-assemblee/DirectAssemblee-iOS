//
//  TimelineEventViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 07/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift

class TimelineEventViewModel: BaseViewModel, VoteResultInfo {
    
    var timelineEvent:TimelineEvent
    
    var dateText = Variable<String>("")
    var titleText = Variable<String>("")
    var descriptionText = Variable<String>("")
    var userDeputyVoteResultText = Variable<String>("")
    var themeImageName = Variable<String>("")
    var themeText = Variable<String>("")
    var isAdoptedText = Variable<String>("")
    var deputyImageName = Variable<String>("")
    
    var isVoteEvent = false
    var isAdoptedStatusColorCode = Constants.Color.greenColorCode
    var userDeputyVoteColorCode = Constants.Color.greenColorCode
    var userDeputyVoteResultImageName:String?
    
    init(timelineEvent:TimelineEvent) {
        
        self.timelineEvent = timelineEvent
        super.init()
        
        self.configure()
    }
    
    // MARK: - Configure
    
    private func configure() {
        self.configureBallotVoteInfo()
        self.configureDeputyVoteInfo()
    }
    
    private func configureBallotVoteInfo() {

        self.dateText.value = self.timelineEvent.date.toString(withFormat: "dd/MM/yyyy", withLocale: "fr")
        self.titleText.value = self.timelineEvent.title
        self.descriptionText.value = self.timelineEvent.description
        self.themeImageName.value = self.timelineEvent.theme.type.imageName
        self.themeText.value = self.timelineEvent.theme.name
        
        if let voteInfo = self.timelineEvent.voteInfo {
            self.isAdoptedStatusColorCode = voteInfo.isAdopted ? Constants.Color.greenColorCode : Constants.Color.redColorCode
            self.isAdoptedText.value = self.getIsAdoptedText() ?? ""
            self.isVoteEvent = true
        } else {
            self.isAdoptedStatusColorCode = Constants.Color.grayColorCode
            self.isVoteEvent = false
        }

    }
    
    private func getIsAdoptedText() -> String? {
        
        guard let voteInfo = self.timelineEvent.voteInfo else {
            return nil
        }
        
        if self.timelineEvent.type == .motionOfCensureVote {
            return voteInfo.isAdopted ? R.string.localizable.timeline_motion_of_censure_adopted().uppercased() : R.string.localizable.timeline_motion_of_censure_not_adopted().uppercased()
        } else {
            return voteInfo.isAdopted ? R.string.localizable.timeline_ballot_adopted().uppercased() : R.string.localizable.timeline_ballot_not_adopted().uppercased()
        }
    }
    
    private func configureDeputyVoteInfo() {
        
        guard let voteInfo = self.timelineEvent.voteInfo else {
            return
        }
        
        self.userDeputyVoteResultText.value = voteInfo.userDeputyVote.voteResult.text.uppercased()
        self.userDeputyVoteColorCode = voteInfo.userDeputyVote.voteResult.colorCode
        self.userDeputyVoteResultImageName = voteInfo.userDeputyVote.voteResult.imageName
    }
    
    
}
