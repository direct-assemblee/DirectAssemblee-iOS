//
//  BallotViewModelTests.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 28/07/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest

@testable import direct_assemblee

class BallotViewModelTests: BaseTests {
    
    func testViewModelShouldBeFilledWithModelCorrectly() {
        
        var timelineEvent = self.testsHelper.timelineEvent()
        timelineEvent.voteInfo?.numberOfNonVoting = 5
        timelineEvent.voteInfo?.numberOfAgainstVotes = 8
        timelineEvent.voteInfo?.numberOfAgreeVotes = 30
        timelineEvent.voteInfo?.numberOfBlankVotes = 15
        timelineEvent.voteInfo?.numberOfMissingVotes = 40
        timelineEvent.voteInfo?.userDeputyVote = UserDeputyVote(voteResult: .agree, userDeputy: UserDeputy(deputyFirstName: "Jean-Michel", deputyLastName: "Blop"))
        timelineEvent.voteInfo?.isAdopted = true
        
        let ballotViewModel = BallotViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(ballotViewModel.yourDeputyText.value == R.string.localizable.your_deputy())

        XCTAssert(ballotViewModel.descriptionText.value == "description")
        XCTAssert(ballotViewModel.dateText.value == "Mercredi 6 Septembre 2017")
        XCTAssert(ballotViewModel.isAdoptedText.value ==  R.string.localizable.timeline_ballot_adopted().uppercased())
        XCTAssert(ballotViewModel.isAdoptedStatusColorCode.value == Constants.Color.greenColorCode)
        XCTAssert(ballotViewModel.userDeputyVoteResultText.value == R.string.localizable.vote_result_for().uppercased())
        XCTAssert(ballotViewModel.userDeputyVoteImageName.value == R.image.icon_deputy.name)
        XCTAssert(ballotViewModel.userDeputyVoteColorCode.value == Constants.Color.greenColorCode)
        XCTAssert(ballotViewModel.isAdopted.value == true)
            
        XCTAssert(ballotViewModel.votesData.value[0] == (30, Constants.Color.greenColorCode, R.string.localizable.vote_result_for()))
        XCTAssert(ballotViewModel.votesData.value[1] == (8, Constants.Color.redColorCode, R.string.localizable.vote_result_against()))
        XCTAssert(ballotViewModel.votesData.value[2] == (15, Constants.Color.grayColorCode, R.string.localizable.vote_result_blank()))
        XCTAssert(ballotViewModel.votesData.value[3] == (40, Constants.Color.orangeColorCode, R.string.localizable.vote_result_missing()))
        XCTAssert(ballotViewModel.votesData.value[4] == (5, Constants.Color.yellowColorCode, R.string.localizable.vote_result_non_voting()))
        
    }
    
    func testViewModelShouldBeFilledWithModelCorrectlyWithSingleValues() {
        
        var timelineEvent = self.testsHelper.timelineEvent()
        timelineEvent.voteInfo?.numberOfNonVoting = 1
        timelineEvent.voteInfo?.numberOfAgainstVotes = 8
        timelineEvent.voteInfo?.numberOfAgreeVotes = 30
        timelineEvent.voteInfo?.numberOfBlankVotes = 15
        timelineEvent.voteInfo?.numberOfMissingVotes = 1
        timelineEvent.voteInfo?.userDeputyVote = UserDeputyVote(voteResult: .agree, userDeputy: UserDeputy(deputyFirstName: "Jean-Michel", deputyLastName: "Blop"))
        timelineEvent.voteInfo?.isAdopted = true
        
        let ballotViewModel = BallotViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(ballotViewModel.votesData.value[3] == (1, Constants.Color.orangeColorCode, R.string.localizable.timeline_event_vote_result_vote_missing()))
        XCTAssert(ballotViewModel.votesData.value[4] == (1, Constants.Color.yellowColorCode, R.string.localizable.vote_result_non_voting()))
        
    }
    
    func testViewModelShouldBeFilledWithModelCorrectlyWithRejectedStatus() {
        
        
        var timelineEvent = self.testsHelper.timelineEvent()
        timelineEvent.voteInfo?.isAdopted = false
        
        let ballotViewModel = BallotViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(ballotViewModel.isAdoptedText.value == R.string.localizable.timeline_ballot_not_adopted().uppercased())
        XCTAssert(ballotViewModel.isAdoptedStatusColorCode.value == Constants.Color.redColorCode)
        XCTAssert(ballotViewModel.isAdopted.value == false)
    }
    
    //MARK: - Deputy vote tests
    
    func testViewModelShouldBeFilledWithModelCorrectlyWithDeputyVoteFor() {
        
        let timelineEvent = self.testsHelper.timelineEvent(withUserDeputyVoteResult: .agree)
        let ballotViewModel = BallotViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(ballotViewModel.userDeputyVoteResultText.value == R.string.localizable.vote_result_for().uppercased())
        XCTAssert(ballotViewModel.userDeputyVoteColorCode.value == Constants.Color.greenColorCode)
        XCTAssert(ballotViewModel.userDeputyVoteImageName.value == R.image.icon_deputy.name)
    }

    func testViewModelShouldBeFilledWithModelCorrectlyWithDeputyVoteAgainst() {
        
        let timelineEvent = self.testsHelper.timelineEvent(withUserDeputyVoteResult: .against)
        let ballotViewModel = BallotViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(ballotViewModel.userDeputyVoteResultText.value == R.string.localizable.vote_result_against().uppercased())
        XCTAssert(ballotViewModel.userDeputyVoteColorCode.value == Constants.Color.redColorCode)
        XCTAssert(ballotViewModel.userDeputyVoteImageName.value == R.image.icon_deputy.name)
    }
    
    func testViewModelShouldBeFilledWithModelCorrectlyWithDeputyVoteMissing() {
        
        let timelineEvent = self.testsHelper.timelineEvent(withUserDeputyVoteResult: .missing)
        let ballotViewModel = BallotViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(ballotViewModel.userDeputyVoteImageName.value == R.image.icon_missing_deputy.name)
        XCTAssert(ballotViewModel.userDeputyVoteColorCode.value == Constants.Color.orangeColorCode)
        XCTAssert(ballotViewModel.userDeputyVoteResultText.value == R.string.localizable.vote_result_missing().uppercased())
    }
    
    func testViewModelShouldBeFilledWithModelCorrectlyWithDeputyVoteNoVoting() {
        
        let timelineEvent = self.testsHelper.timelineEvent(withUserDeputyVoteResult: .nonVoting)
        let ballotViewModel = BallotViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(ballotViewModel.userDeputyVoteImageName.value == R.image.icon_deputy.name)
        XCTAssert(ballotViewModel.userDeputyVoteColorCode.value == Constants.Color.yellowColorCode)
        XCTAssert(ballotViewModel.userDeputyVoteResultText.value == R.string.localizable.vote_result_non_voting().uppercased())
    }
    
    func testViewModelShouldBeFilledWithModelCorrectlyWithDeputyMotionOfCensureSigned() {
        
        let timelineEvent = self.testsHelper.timelineEvent(withUserDeputyVoteResult: .signed)
        let ballotViewModel = BallotViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(ballotViewModel.userDeputyVoteImageName.value == R.image.icon_deputy.name)
        XCTAssert(ballotViewModel.userDeputyVoteColorCode.value == Constants.Color.greenColorCode)
        XCTAssert(ballotViewModel.userDeputyVoteResultText.value == R.string.localizable.timeline_event_motion_of_censure_signed().uppercased())
    }
    
    func testViewModelShouldBeFilledWithModelCorrectlyWithDeputyMotionOfCensureNotSigned() {
        
        let timelineEvent = self.testsHelper.timelineEvent(withUserDeputyVoteResult: .notSigned)
        let ballotViewModel = BallotViewModel(timelineEvent: timelineEvent)
        
        XCTAssert(ballotViewModel.userDeputyVoteImageName.value == R.image.icon_deputy.name)
        XCTAssert(ballotViewModel.userDeputyVoteColorCode.value == Constants.Color.redColorCode)
        XCTAssert(ballotViewModel.userDeputyVoteResultText.value == R.string.localizable.timeline_event_motion_of_censure_not_signed().uppercased())
    }

}
