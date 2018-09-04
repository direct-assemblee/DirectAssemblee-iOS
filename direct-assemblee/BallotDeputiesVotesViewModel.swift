//
//  BallotDeputiesVotesViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 29/05/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift
import RxCocoa

struct BallotVotesViewModels {
    var forDeputiesViewModel: DeputiesListViewModel
    var againstDeputiesViewModel: DeputiesListViewModel
    var blankDeputiesViewModel: DeputiesListViewModel
    var missingDeputiesViewModel: DeputiesListViewModel
    var noVotingDeputiesViewModel: DeputiesListViewModel
}

enum State {
    case loading
    case loaded(data: BallotVotesViewModels)
    case error(error: DAError)
}

class BallotDeputiesVotesViewModel: BaseViewModel, DeputySearchViewModel {
    
    private var api: Api
    private var timelineEvent: TimelineEvent
    private var ballotDeputiesVotes: BallotDeputiesVotes
    
    var themeText = Variable<String>("")
    var titleText = Variable<String>("")
    var enterNamePlaceholderText = R.string.localizable.search_all_deputies_placeholder()
    var ballotVotesViewModels = PublishSubject<BallotVotesViewModels>()
    var state: BehaviorRelay<State> = BehaviorRelay(value: .loading)
    var votesLabels = Variable<[DeputyVoteTypeViewModel]>([])
    var searchText = PublishSubject<String>()
    
    init(api: Api, timelineEvent: TimelineEvent) {
        
        self.api = api
        self.timelineEvent = timelineEvent
        
        self.ballotDeputiesVotes = BallotDeputiesVotes(
            forDeputies: [],
            againstDeputies: [],
            blankDeputies: [],
            missingDeputies: [],
            nonVotingDeputies: []
        )
        
        super.init()
        
        self.configureTitle()
        self.configureSearch()
        self.loadBallotDeputiesVotes()
    }
    
    // MARK: - Configure
    
    func loadBallotDeputiesVotes() {
        
        self.api.deputiesVotes(forBallotId: self.timelineEvent.id)
            .subscribe(onNext: { [weak self] ballotDeputiesVotes in
                self?.ballotDeputiesVotes = ballotDeputiesVotes
                self?.configureVotesForView()
                }, onError: { [weak self] error in
                    self?.state.accept(.error(error: error as! DAError))
            }).disposed(by: self.disposeBag)
    }
    
    func configureTitle() {
        self.themeText.value = self.timelineEvent.theme.name
        self.titleText.value = self.timelineEvent.title
    }
    
    private func configureSearch() {
        
        self.searchText
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribe(onNext: { [unowned self] searchText in
                
                let ballotDeputiesVotes = self.getFilteredBallotDeputiesVotes(searchText: searchText)
                let ballotVotesViewModels = self.buildBallotVotesViewModels(ballotDeputiesVotes: ballotDeputiesVotes)
                
                self.state.accept(.loaded(data: ballotVotesViewModels))
                self.votesLabels.value = self.buildVotesLabels(ballotDeputiesVotes: ballotDeputiesVotes)
                
            }).disposed(by: self.disposeBag)
    }
    
    // MARK: - Search helpers
    
    private func getFilteredBallotDeputiesVotes(searchText: String) -> BallotDeputiesVotes {
        
        let filteredForDeputies = self.search(text: searchText, inDeputies: self.ballotDeputiesVotes.forDeputies)
        let filteredAgainstDeputies = self.search(text: searchText, inDeputies: self.ballotDeputiesVotes.againstDeputies)
        let filteredBlankDeputies = self.search(text: searchText, inDeputies: self.ballotDeputiesVotes.blankDeputies)
        let filteredMissingDeputies = self.search(text: searchText, inDeputies: self.ballotDeputiesVotes.missingDeputies)
        let filteredNonVotingDeputies = self.search(text: searchText, inDeputies: self.ballotDeputiesVotes.nonVotingDeputies)
        
        return BallotDeputiesVotes(forDeputies: filteredForDeputies,
                                   againstDeputies: filteredAgainstDeputies,
                                   blankDeputies: filteredBlankDeputies,
                                   missingDeputies: filteredMissingDeputies,
                                   nonVotingDeputies: filteredNonVotingDeputies)
    }
    
    private func search(text searchText: String, inDeputies deputies: [DeputySummary]) ->  [DeputySummary] {
        return searchText.isEmpty ? deputies : deputies.filter({ [unowned self] deputy -> Bool in
            return self.isTextFound(searchText, inDeputy: deputy)
        })
    }
    
    // MARK: - Others Helpers
    
    private func configureVotesForView() {
        self.ballotDeputiesVotes.sortInAlphabeticalOrder()
        let ballotVotesViewModels = self.buildBallotVotesViewModels(ballotDeputiesVotes: self.ballotDeputiesVotes)
        self.state.accept(.loaded(data: ballotVotesViewModels))
        self.votesLabels.value = self.buildVotesLabels(ballotDeputiesVotes: self.ballotDeputiesVotes)
    }
    
    private func buildVotesLabels(ballotDeputiesVotes: BallotDeputiesVotes) -> [DeputyVoteTypeViewModel] {
        
        return [DeputyVoteTypeViewModel(voteTypeLabel: "\(R.string.localizable.vote_result_for()) (\(ballotDeputiesVotes.forDeputies.count))"),
                DeputyVoteTypeViewModel(voteTypeLabel: "\(R.string.localizable.vote_result_against()) (\(ballotDeputiesVotes.againstDeputies.count))"),
                DeputyVoteTypeViewModel(voteTypeLabel: "\(R.string.localizable.vote_result_blank()) (\(ballotDeputiesVotes.blankDeputies.count))"),
                DeputyVoteTypeViewModel(voteTypeLabel: "\(R.string.localizable.vote_result_missing()) (\(ballotDeputiesVotes.missingDeputies.count))"),
                DeputyVoteTypeViewModel(voteTypeLabel: "\(R.string.localizable.vote_result_non_voting()) (\(ballotDeputiesVotes.nonVotingDeputies.count))")]
    }
    
    private func buildBallotVotesViewModels(ballotDeputiesVotes: BallotDeputiesVotes) -> BallotVotesViewModels {
        
        return BallotVotesViewModels(forDeputiesViewModel: DeputiesListViewModel(deputies: ballotDeputiesVotes.forDeputies),
                                     againstDeputiesViewModel: DeputiesListViewModel(deputies: ballotDeputiesVotes.againstDeputies),
                                     blankDeputiesViewModel: DeputiesListViewModel(deputies: ballotDeputiesVotes.blankDeputies),
                                     missingDeputiesViewModel: DeputiesListViewModel(deputies: ballotDeputiesVotes.missingDeputies),
                                     noVotingDeputiesViewModel: DeputiesListViewModel(deputies: ballotDeputiesVotes.nonVotingDeputies))
    }
    

}
