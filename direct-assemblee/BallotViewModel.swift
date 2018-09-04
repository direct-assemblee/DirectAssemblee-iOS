//
//  BallotViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 28/07/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift

enum DisplayVotesDetailStatus {
    case selected
    case readyToDisplay(viewModel: BallotDeputiesVotesViewModel)
}

class BallotViewModel: BaseViewModel {
    
    private var timelineEvent:TimelineEvent
    
    var assemblyText = Variable<String>(R.string.localizable.the_assembly())
    var yourDeputyText = Variable<String>(R.string.localizable.your_deputy())
    var readMoreText = Variable<String>(R.string.localizable.read_more())
    var seeDetailsText = Variable<String>(R.string.localizable.ballot_detail_votes())
    var descriptionText = Variable<String>("")
    
    var userDeputyVoteResultText = Variable<String>("")
    var userDeputyVoteImageName = Variable<String>("")
    var userDeputyVoteColorCode = Variable<String>("")
    
    var isAdoptedText = Variable<String>("")
    var isAdoptedStatusColorCode = Variable<String>("")
    var isAdopted = Variable<Bool>(false)
    
    var votesData = Variable<[(value:Int, colorCode:String, label:String)]>([])
    var dateText = Variable<String>("")
    var readMoreUrl:URL?
    
    var didTapOnReadMore = PublishSubject<Void>()
    var displayVotesDetailStatus = PublishSubject<DisplayVotesDetailStatus>()
    
    init(timelineEvent: TimelineEvent) {
        
        self.timelineEvent = timelineEvent
        super.init()
        
        self.configure()
    }
    
    // MARK: - Configure
    
    private func configure() {
        
        self.readMoreUrl = URL(string:self.timelineEvent.fileUrl ?? "")
        self.descriptionText.value = self.timelineEvent.description
        self.dateText.value = self.timelineEvent.date.toString(withFormat: "EEEE d MMMM yyyy", withLocale: "fr").capitalized
        
        self.configureBallotVote()
        self.configureUserDeputyVote()
        self.configureAllVotesChart()
        self.configureDidTapOnReadMore()
        self.configureDisplayVotesDetailStatus()
    }
    
    private func configureBallotVote() {
        
        guard let voteInfo = self.timelineEvent.voteInfo else {
            return
        }
        
        if self.timelineEvent.type == .motionOfCensureVote {
            self.isAdoptedText.value = voteInfo.isAdopted ? R.string.localizable.timeline_motion_of_censure_adopted().uppercased() : R.string.localizable.timeline_motion_of_censure_not_adopted().uppercased()
        } else {
            self.isAdoptedText.value = voteInfo.isAdopted ? R.string.localizable.timeline_ballot_adopted().uppercased() : R.string.localizable.timeline_ballot_not_adopted().uppercased()
        }
        
        self.isAdopted.value = voteInfo.isAdopted
        self.isAdoptedStatusColorCode.value = voteInfo.isAdopted ? Constants.Color.greenColorCode : Constants.Color.redColorCode
        
    }
    
    private func configureUserDeputyVote() {
        
        guard let userDeputyVote = self.timelineEvent.voteInfo?.userDeputyVote else {
            return
        }
        
        self.userDeputyVoteResultText.value = userDeputyVote.voteResult.text.uppercased()
        self.userDeputyVoteImageName.value = userDeputyVote.voteResult.imageName
        self.userDeputyVoteColorCode.value = userDeputyVote.voteResult.colorCode
    }
    
    private func configureAllVotesChart() {
        
        guard let voteInfo = self.timelineEvent.voteInfo else {
            return
        }
        
        let agreeVotesTuple = (value:voteInfo.numberOfAgreeVotes, colorCode:Constants.Color.greenColorCode, label:R.string.localizable.vote_result_for())
        let againstVotesTuple = (value:voteInfo.numberOfAgainstVotes, colorCode:Constants.Color.redColorCode, label:R.string.localizable.vote_result_against())
        let blankVotesTuple = (value:voteInfo.numberOfBlankVotes, colorCode:Constants.Color.grayColorCode, label:R.string.localizable.vote_result_blank())
        let missingVotesTuple = (value:voteInfo.numberOfMissingVotes, colorCode:Constants.Color.orangeColorCode, label: R.string.localizable.vote_result_missing())
        let nonVotingTuple = (value:voteInfo.numberOfNonVoting, colorCode:Constants.Color.yellowColorCode, label: R.string.localizable.vote_result_non_voting())
        
        self.votesData = Variable<[(value:Int, colorCode:String, label:String)]>([agreeVotesTuple, againstVotesTuple, blankVotesTuple, missingVotesTuple, nonVotingTuple])
    }
    
    private func configureDidTapOnReadMore() {
        
        self.didTapOnReadMore.subscribe(onNext: { [weak self] _ in
            self?.sendTagEventForReadMore()
        }).disposed(by: self.disposeBag)
    }
    
    private func configureDisplayVotesDetailStatus() {
        
        self.displayVotesDetailStatus
            //Eviter une reetrancy anomaly : on dispatche chaque évènement l'un après l'autre
            //En effet, on envoie un nouvel évènement au subject avant que l'observer aie fini de lire l'évènement en cours
            .observeOn(SerialDispatchQueueScheduler.init(qos: .default))
            .subscribe(onNext: { status in
            switch status {
            case .selected:
                let viewModel = BallotDeputiesVotesViewModel(api: SingletonManager.sharedApiInstance, timelineEvent: self.timelineEvent)
                self.displayVotesDetailStatus.onNext(.readyToDisplay(viewModel: viewModel))
            default:
                break
            }
        }).disposed(by: self.disposeBag)
    }
    
    //MARK: - Tagging
    
    private func sendTagEventForReadMore() {
        TaggageManager.sendEvent(eventName: "display_more_timeline_event", forTimelineEvent: self.timelineEvent)
    }
    
}
