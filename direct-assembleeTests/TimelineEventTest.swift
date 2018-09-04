//
//  ActivityTest.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 06/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest

@testable import direct_assemblee

class TimelineEventTest: BaseTests {
    
    
    func testNumberOfEventsFromTimelineWebserviceShouldBeOk() {
        
        let asyncExpectation = expectation(description: "timelineEvents")
        var retrievedEvents = [TimelineEvent]()
        
        self.testsHelper.timelineApi.timeline(forDeputy: 1, page: 0).subscribe(onNext: { events in
            asyncExpectation.fulfill()
            retrievedEvents = events
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedEvents.count == 15)
        }
    }
    
    func testQuestionEventFromTimelineWebserviceShouldBeBuiltCorrectly() {
        
        let asyncExpectation = expectation(description: "timelineEvents")
        var retrievedEvent:TimelineEvent?
        
        self.testsHelper.timelineApi.timeline(forDeputy: 1, page: 0).subscribe(onNext: { events in
            asyncExpectation.fulfill()
            retrievedEvent = events[0]
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedEvent?.id == 1)
            XCTAssert(retrievedEvent?.type == .question)
            XCTAssert(retrievedEvent?.date.toString(withFormat: "dd/MM/yyyy") == "16/11/2016")
            XCTAssert(retrievedEvent?.title == "Question n*7272 au Gouv")
            XCTAssert(retrievedEvent?.theme.type == .transportNetwork)
            XCTAssert(retrievedEvent?.theme.name == "blop")
            XCTAssert(retrievedEvent?.description == "description")
            XCTAssert(retrievedEvent?.voteInfo == nil)
            XCTAssert(retrievedEvent?.fileUrl == "http://www.blop.org")
        }
    }
    
    func testSolemnVoteEventFromTimelineWebserviceShouldBeBuiltCorrectly() {
        
        let asyncExpectation = expectation(description: "timelineEvents")
        var retrievedEvent:TimelineEvent?
        
        self.testsHelper.timelineApi.timeline(forDeputy: 1, page: 0).subscribe(onNext: { events in
            asyncExpectation.fulfill()
            retrievedEvent = events[1]
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedEvent?.id == 1122)
            XCTAssert(retrievedEvent?.type == .solemnVote)
            XCTAssert(retrievedEvent?.date.toString(withFormat: "dd/MM/yyyy") == "21/12/2014")
            XCTAssert(retrievedEvent?.title == "Vote solennel pour")
            XCTAssert(retrievedEvent?.theme.type == .powersAndConstitution)
            XCTAssert(retrievedEvent?.theme.name == "Ordonnances sur le renforcement du dialogue social")
            XCTAssert(retrievedEvent?.description == "description")
            XCTAssert(retrievedEvent?.fileUrl == "http://www.blop.org")
            
            let voteInfo = (retrievedEvent?.voteInfo)!
            
            XCTAssert(voteInfo.userDeputyVote.voteResult == .agree)
            XCTAssert(voteInfo.isAdopted == true)
            XCTAssert(voteInfo.userDeputyVote.userDeputy.deputyFirstName == "JM")
            XCTAssert(voteInfo.userDeputyVote.userDeputy.deputyLastName == "Député")
            XCTAssert(voteInfo.numberOfTotalVotes == 242)
            XCTAssert(voteInfo.numberOfAgreeVotes == 27)
            XCTAssert(voteInfo.numberOfAgainstVotes == 212)
            XCTAssert(voteInfo.numberOfNonVoting == 2)
            XCTAssert(voteInfo.numberOfBlankVotes == 3)
            XCTAssert(voteInfo.numberOfMissingVotes == 333)
        }
    }
    
    func testOrdinaryVoteEventFromTimelineWebserviceShouldBeBuiltCorrectlyWithAgreeResult() {
        
        let asyncExpectation = expectation(description: "timelineEvents")
        var retrievedEvent:TimelineEvent?
        
        self.testsHelper.timelineApi.timeline(forDeputy: 1, page: 0).subscribe(onNext: { events in
            asyncExpectation.fulfill()
            retrievedEvent = events[2]
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedEvent?.id == 1123)
            XCTAssert(retrievedEvent?.type == .ordinaryVote)
            XCTAssert(retrievedEvent?.date.toString(withFormat: "dd/MM/yyyy") == "21/12/2014")
            XCTAssert(retrievedEvent?.title == "vote ordinaire pour")
            XCTAssert(retrievedEvent?.description == "description")
            XCTAssert(retrievedEvent?.fileUrl == "http://www.blop.org")
            
            let voteInfo = (retrievedEvent?.voteInfo)!
            
            XCTAssert(voteInfo.userDeputyVote.voteResult == .agree)
            XCTAssert(voteInfo.isAdopted == false)
            XCTAssert(voteInfo.userDeputyVote.userDeputy.deputyFirstName == "JM")
            XCTAssert(voteInfo.userDeputyVote.userDeputy.deputyLastName == "Député")
            XCTAssert(voteInfo.numberOfTotalVotes == 242)
            XCTAssert(voteInfo.numberOfAgreeVotes == 27)
            XCTAssert(voteInfo.numberOfAgainstVotes == 212)
            XCTAssert(voteInfo.numberOfNonVoting == 2)
            XCTAssert(voteInfo.numberOfBlankVotes == 3)
            XCTAssert(voteInfo.numberOfMissingVotes == 333)
        }
    }
    
    func testOrdinaryVoteEventFromTimelineWebserviceShouldBeBuiltCorrectlyWithAgainstResult() {
        
        let asyncExpectation = expectation(description: "timelineEvents")
        var retrievedEvent:TimelineEvent?
        
        self.testsHelper.timelineApi.timeline(forDeputy: 1, page: 0).subscribe(onNext: { events in
            asyncExpectation.fulfill()
            retrievedEvent = events[3]
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedEvent?.id == 1124)
            XCTAssert(retrievedEvent?.type == .ordinaryVote)
            XCTAssert(retrievedEvent?.date.toString(withFormat: "dd/MM/yyyy") == "21/12/2014")
            XCTAssert(retrievedEvent?.title == "Vote ordinaire contre")
            XCTAssert(retrievedEvent?.description == "description")
            XCTAssert(retrievedEvent?.fileUrl == "http://www.blop.org")
            
            let voteInfo = (retrievedEvent?.voteInfo)!
            XCTAssert(voteInfo.userDeputyVote.voteResult == .against)
            XCTAssert(voteInfo.isAdopted == true)
            XCTAssert(voteInfo.userDeputyVote.userDeputy.deputyFirstName == "JM")
            XCTAssert(voteInfo.userDeputyVote.userDeputy.deputyLastName == "Député")
            XCTAssert(voteInfo.numberOfTotalVotes == 242)
            XCTAssert(voteInfo.numberOfAgreeVotes == 27)
            XCTAssert(voteInfo.numberOfAgainstVotes == 212)
            XCTAssert(voteInfo.numberOfNonVoting == 2)
            XCTAssert(voteInfo.numberOfBlankVotes == 3)
            XCTAssert(voteInfo.numberOfMissingVotes == 333)
            
        }
    }
    
    func testOrdinaryVoteEventFromTimelineWebserviceShouldBeBuiltCorrectlyWithMissingResult() {
        
        let asyncExpectation = expectation(description: "timelineEvents")
        var retrievedEvent:TimelineEvent?
        
        self.testsHelper.timelineApi.timeline(forDeputy: 1, page: 0).subscribe(onNext: { events in
            asyncExpectation.fulfill()
            retrievedEvent = events[4]
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedEvent?.id == 1125)
            XCTAssert(retrievedEvent?.type == .ordinaryVote)
            XCTAssert(retrievedEvent?.date.toString(withFormat: "dd/MM/yyyy") == "21/12/2014")
            XCTAssert(retrievedEvent?.title == "Vote ordinaire absent")
            XCTAssert(retrievedEvent?.description == "description")
            XCTAssert(retrievedEvent?.fileUrl == "http://www.blop.org")
            
            let voteInfo = (retrievedEvent?.voteInfo)!
            XCTAssert(voteInfo.userDeputyVote.voteResult == .missing)
            XCTAssert(voteInfo.isAdopted == true)
            XCTAssert(voteInfo.userDeputyVote.userDeputy.deputyFirstName == "JM")
            XCTAssert(voteInfo.userDeputyVote.userDeputy.deputyLastName == "Député")
            XCTAssert(voteInfo.numberOfTotalVotes == 242)
            XCTAssert(voteInfo.numberOfAgreeVotes == 27)
            XCTAssert(voteInfo.numberOfAgainstVotes == 212)
            XCTAssert(voteInfo.numberOfNonVoting == 2)
            XCTAssert(voteInfo.numberOfBlankVotes == 3)
            XCTAssert(voteInfo.numberOfMissingVotes == 333)
            
        }
    }
    
    
    func testOrdinaryVoteEventFromTimelineWebserviceShouldBeBuiltCorrectlyWithBlankResult() {
        
        let asyncExpectation = expectation(description: "timelineEvents")
        var retrievedEvent:TimelineEvent?
        
        self.testsHelper.timelineApi.timeline(forDeputy: 1, page: 0).subscribe(onNext: { events in
            asyncExpectation.fulfill()
            retrievedEvent = events[5]
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedEvent?.id == 1126)
            XCTAssert(retrievedEvent?.type == .ordinaryVote)
            XCTAssert(retrievedEvent?.date.toString(withFormat: "dd/MM/yyyy") == "21/12/2014")
            XCTAssert(retrievedEvent?.title == "vote ordinaire abstention")
            XCTAssert(retrievedEvent?.description == "description")
            XCTAssert(retrievedEvent?.fileUrl == "http://www.blop.org")
            
            let voteInfo = (retrievedEvent?.voteInfo)!
            XCTAssert(voteInfo.userDeputyVote.voteResult == .blank)
            XCTAssert(voteInfo.isAdopted == true)
            XCTAssert(voteInfo.userDeputyVote.userDeputy.deputyFirstName == "JM")
            XCTAssert(voteInfo.userDeputyVote.userDeputy.deputyLastName == "Député")
            XCTAssert(voteInfo.numberOfTotalVotes == 242)
            XCTAssert(voteInfo.numberOfAgreeVotes == 27)
            XCTAssert(voteInfo.numberOfAgainstVotes == 212)
            XCTAssert(voteInfo.numberOfNonVoting == 2)
            XCTAssert(voteInfo.numberOfBlankVotes == 3)
            XCTAssert(voteInfo.numberOfMissingVotes == 333)
            
        }
    }
    
    
    func testOrdinaryVoteEventFromTimelineWebserviceShouldBeBuiltCorrectlyWithNonVotingResult() {
        
        let asyncExpectation = expectation(description: "timelineEvents")
        var retrievedEvent:TimelineEvent?
        
        self.testsHelper.timelineApi.timeline(forDeputy: 1, page: 0).subscribe(onNext: { events in
            asyncExpectation.fulfill()
            retrievedEvent = events[6]
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedEvent?.id == 1127)
            XCTAssert(retrievedEvent?.type == .ordinaryVote)
            XCTAssert(retrievedEvent?.date.toString(withFormat: "dd/MM/yyyy") == "21/12/2014")
            XCTAssert(retrievedEvent?.title == "vote ordinaire non votant")
            XCTAssert(retrievedEvent?.description == "description")
            XCTAssert(retrievedEvent?.fileUrl == "http://www.blop.org")
            
            let voteInfo = (retrievedEvent?.voteInfo)!
            XCTAssert(voteInfo.userDeputyVote.voteResult == .nonVoting)
            XCTAssert(voteInfo.isAdopted == true)
            XCTAssert(voteInfo.userDeputyVote.userDeputy.deputyFirstName == "JM")
            XCTAssert(voteInfo.userDeputyVote.userDeputy.deputyLastName == "Député")
            XCTAssert(voteInfo.numberOfTotalVotes == 242)
            XCTAssert(voteInfo.numberOfAgreeVotes == 27)
            XCTAssert(voteInfo.numberOfAgainstVotes == 212)
            XCTAssert(voteInfo.numberOfNonVoting == 2)
            XCTAssert(voteInfo.numberOfBlankVotes == 3)
            XCTAssert(voteInfo.numberOfMissingVotes == 333)
            
        }
    }
    
    func testOtherVoteEventFromTimelineWebserviceShouldBeBuiltCorrectly() {
        
        let asyncExpectation = expectation(description: "timelineEvents")
        var retrievedEvent:TimelineEvent?
        
        self.testsHelper.timelineApi.timeline(forDeputy: 1, page: 0).subscribe(onNext: { events in
            asyncExpectation.fulfill()
            retrievedEvent = events[7]
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedEvent?.id == 1128)
            XCTAssert(retrievedEvent?.type == .otherVote)
            XCTAssert(retrievedEvent?.date.toString(withFormat: "dd/MM/yyyy") == "21/12/2014")
            XCTAssert(retrievedEvent?.title == "autre vote")
            XCTAssert(retrievedEvent?.description == "description")
            XCTAssert(retrievedEvent?.fileUrl == "http://www.blop.org")
            
            let voteInfo = (retrievedEvent?.voteInfo)!
            
            XCTAssert(voteInfo.userDeputyVote.voteResult == .agree)
            XCTAssert(voteInfo.isAdopted == true)
            XCTAssert(voteInfo.userDeputyVote.userDeputy.deputyFirstName == "JM")
            XCTAssert(voteInfo.userDeputyVote.userDeputy.deputyLastName == "Député")
            XCTAssert(voteInfo.numberOfTotalVotes == 242)
            XCTAssert(voteInfo.numberOfAgreeVotes == 27)
            XCTAssert(voteInfo.numberOfAgainstVotes == 212)
            XCTAssert(voteInfo.numberOfNonVoting == 2)
            XCTAssert(voteInfo.numberOfBlankVotes == 3)
            XCTAssert(voteInfo.numberOfMissingVotes == 333)
        }
    }
    
    func testMotionOfCensureVoteEventFromTimelineWebserviceShouldBeBuiltCorrectlyWithSignedResult() {
        
        let asyncExpectation = expectation(description: "timelineEvents")
        var retrievedEvent:TimelineEvent?
        
        self.testsHelper.timelineApi.timeline(forDeputy: 1, page: 0).subscribe(onNext: { events in
            asyncExpectation.fulfill()
            retrievedEvent = events[8]
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedEvent?.id == 1129)
            XCTAssert(retrievedEvent?.type == .motionOfCensureVote)
            XCTAssert(retrievedEvent?.date.toString(withFormat: "dd/MM/yyyy") == "21/12/2014")
            XCTAssert(retrievedEvent?.title == "motion de censure signée")
            XCTAssert(retrievedEvent?.description == "description")
            XCTAssert(retrievedEvent?.fileUrl == "http://www.blop.org")
            
            let voteInfo = (retrievedEvent?.voteInfo)!
            
            XCTAssert(voteInfo.userDeputyVote.voteResult == .signed)
            XCTAssert(voteInfo.isAdopted == true)
            XCTAssert(voteInfo.userDeputyVote.userDeputy.deputyFirstName == "JM")
            XCTAssert(voteInfo.userDeputyVote.userDeputy.deputyLastName == "Député")
            XCTAssert(voteInfo.numberOfTotalVotes == 242)
            XCTAssert(voteInfo.numberOfAgreeVotes == 27)
            XCTAssert(voteInfo.numberOfAgainstVotes == 212)
            XCTAssert(voteInfo.numberOfNonVoting == 2)
            XCTAssert(voteInfo.numberOfBlankVotes == 3)
            XCTAssert(voteInfo.numberOfMissingVotes == 333)
        }
    }
    
    func testMotionOfCensureVoteEventFromTimelineWebserviceShouldBeBuiltCorrectlyWithNotSignedResult() {
        
        let asyncExpectation = expectation(description: "timelineEvents")
        var retrievedEvent:TimelineEvent?
        
        self.testsHelper.timelineApi.timeline(forDeputy: 1, page: 0).subscribe(onNext: { events in
            asyncExpectation.fulfill()
            retrievedEvent = events[9]
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedEvent?.id == 1130)
            XCTAssert(retrievedEvent?.type == .motionOfCensureVote)
            XCTAssert(retrievedEvent?.date.toString(withFormat: "dd/MM/yyyy") == "21/12/2014")
            XCTAssert(retrievedEvent?.title == "motion de censure non signée")
            XCTAssert(retrievedEvent?.description == "description")
            XCTAssert(retrievedEvent?.fileUrl == "http://www.blop.org")
            
            let voteInfo = (retrievedEvent?.voteInfo)!
            
            XCTAssert(voteInfo.userDeputyVote.voteResult == .notSigned)
            XCTAssert(voteInfo.isAdopted == true)
            XCTAssert(voteInfo.userDeputyVote.userDeputy.deputyFirstName == "JM")
            XCTAssert(voteInfo.userDeputyVote.userDeputy.deputyLastName == "Député")
            XCTAssert(voteInfo.numberOfTotalVotes == 242)
            XCTAssert(voteInfo.numberOfAgreeVotes == 27)
            XCTAssert(voteInfo.numberOfAgainstVotes == 212)
            XCTAssert(voteInfo.numberOfNonVoting == 2)
            XCTAssert(voteInfo.numberOfBlankVotes == 3)
            XCTAssert(voteInfo.numberOfMissingVotes == 333)
        }
    }
    
    func testReportEventFromTimelineWebserviceShouldBeBuiltCorrectlyWith() {
        
        let asyncExpectation = expectation(description: "timelineEvents")
        var retrievedEvent:TimelineEvent?
        
        self.testsHelper.timelineApi.timeline(forDeputy: 1, page: 0).subscribe(onNext: { events in
            asyncExpectation.fulfill()
            retrievedEvent = events[10]
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedEvent?.id == 6)
            XCTAssert(retrievedEvent?.type == .report)
            XCTAssert(retrievedEvent?.date.toString(withFormat: "dd/MM/yyyy") == "21/12/2014")
            XCTAssert(retrievedEvent?.title == "rapport")
            XCTAssert(retrievedEvent?.description == "description")
            XCTAssert(retrievedEvent?.voteInfo == nil)
            XCTAssert(retrievedEvent?.fileUrl == "http://www.blop.org")
        }
    }
    
    func testLawProposalEventFromTimelineWebserviceShouldBeBuiltCorrectlyWith() {
        
        let asyncExpectation = expectation(description: "timelineEvents")
        var retrievedEvent:TimelineEvent?
        
        self.testsHelper.timelineApi.timeline(forDeputy: 1, page: 0).subscribe(onNext: { events in
            asyncExpectation.fulfill()
            retrievedEvent = events[11]
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedEvent?.id == 5)
            XCTAssert(retrievedEvent?.type == .lawProposal)
            XCTAssert(retrievedEvent?.date.toString(withFormat: "dd/MM/yyyy") == "21/12/2014")
            XCTAssert(retrievedEvent?.title == "proposition de loi")
            XCTAssert(retrievedEvent?.description == "description")
            XCTAssert(retrievedEvent?.voteInfo == nil)
            XCTAssert(retrievedEvent?.fileUrl == "http://www.blop.org")
            XCTAssert(retrievedEvent?.extraInfo[Constants.TimelineEventExtraInfoKey.lawMotives] as! String == "motifs")
        }
    }
    
    func testCosignedLawProposalEventFromTimelineWebserviceShouldBeBuiltCorrectlyWith() {
        
        let asyncExpectation = expectation(description: "timelineEvents")
        var retrievedEvent:TimelineEvent?
        
        self.testsHelper.timelineApi.timeline(forDeputy: 1, page: 0).subscribe(onNext: { events in
            asyncExpectation.fulfill()
            retrievedEvent = events[12]
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedEvent?.id == 4)
            XCTAssert(retrievedEvent?.type == .cosignedLawProposal)
            XCTAssert(retrievedEvent?.date.toString(withFormat: "dd/MM/yyyy") == "21/12/2014")
            XCTAssert(retrievedEvent?.title == "proposition de loi cosignée")
            XCTAssert(retrievedEvent?.description == "description")
            XCTAssert(retrievedEvent?.voteInfo == nil)
            XCTAssert(retrievedEvent?.fileUrl == "http://www.blop.org")
            XCTAssert(retrievedEvent?.extraInfo[Constants.TimelineEventExtraInfoKey.lawMotives] as! String == "motifs")
        }
    }
    
    func testCommissionEventFromTimelineWebserviceShouldBeBuiltCorrectlyWith() {
        
        let asyncExpectation = expectation(description: "timelineEvents")
        var retrievedEvent:TimelineEvent?
        
        self.testsHelper.timelineApi.timeline(forDeputy: 1, page: 0).subscribe(onNext: { events in
            asyncExpectation.fulfill()
            retrievedEvent = events[13]
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedEvent?.id == 3)
            XCTAssert(retrievedEvent?.type == .commission)
            XCTAssert(retrievedEvent?.date.toString(withFormat: "dd/MM/yyyy") == "21/12/2014")
            XCTAssert(retrievedEvent?.title == "commission")
            XCTAssert(retrievedEvent?.description == "description")
            XCTAssert(retrievedEvent?.voteInfo == nil)
            XCTAssert(retrievedEvent?.fileUrl == "http://www.blop.org")
            XCTAssert(retrievedEvent?.extraInfo[Constants.TimelineEventExtraInfoKey.commissionName] as! String == "Commission de la bienveillance")
            XCTAssert(retrievedEvent?.extraInfo[Constants.TimelineEventExtraInfoKey.commissionTime] as! String == "Séance de 9 heures 30")
        }
    }
    
    func testPublicSessionEventFromTimelineWebserviceShouldBeBuiltCorrectlyWith() {
        
        let asyncExpectation = expectation(description: "timelineEvents")
        var retrievedEvent:TimelineEvent?
        
        self.testsHelper.timelineApi.timeline(forDeputy: 1, page: 0).subscribe(onNext: { events in
            asyncExpectation.fulfill()
            retrievedEvent = events[14]
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedEvent?.id == 2)
            XCTAssert(retrievedEvent?.type == .publicSession)
            XCTAssert(retrievedEvent?.date.toString(withFormat: "dd/MM/yyyy") == "21/12/2014")
            XCTAssert(retrievedEvent?.title == "session publique")
            XCTAssert(retrievedEvent?.description == "description")
            XCTAssert(retrievedEvent?.voteInfo == nil)
            XCTAssert(retrievedEvent?.fileUrl == "http://www.blop.org")
        }
    }
    
    func testThemesShouldBeParsedCorrectly() {
        
        let themesToTest = [
            (id: 0, name:"Catégorisation à venir", imageName: "ic_non_categorise"),
            (id: 1, name:"Affaires étrangères", imageName: "ic_affaires_etrangeres"),
            (id: 2, name:"Agriculture", imageName: "ic_agriculture"),
            (id: 3, name:"Aménagement du territoire", imageName: "ic_amenagement_territoire"),
            (id: 4, name:"Anciens combattants", imageName: "ic_anciens_combattants"),
            (id: 5, name:"Budget", imageName: "ic_budget"),
            (id: 6, name:"Collectivités territoriales", imageName: "ic_collectivites_territoriales"),
            (id: 7, name:"Culture", imageName: "ic_culture"),
            (id: 8, name:"Défense", imageName: "ic_defense"),
            (id: 9, name:"Economie et finances, fiscalité", imageName: "ic_economie"),
            (id: 10, name:"Education", imageName: "ic_education"),
            (id: 11, name:"Energie", imageName: "ic_energie"),
            (id: 12, name:"Entreprises", imageName: "ic_entreprises"),
            (id: 13, name:"Environnement", imageName: "ic_environnement"),
            (id: 14, name:"Famille", imageName: "ic_famille"),
            (id: 15, name:"Fonction publique", imageName: "ic_fonction_publique"),
            (id: 16, name:"Justice", imageName: "ic_justice"),
            (id: 17, name:"Logement et urbanisme", imageName: "ic_logement_urbanisme"),
            (id: 18, name:"Outre-mer", imageName: "ic_outre_mer"),
            (id: 19, name:"PME, commerce et artisanat", imageName: "ic_pme_commerce_artisanat"),
            (id: 20, name:"Police et sécurité", imageName: "ic_police_securite"),
            (id: 21, name:"Pouvoirs publics et Constitution", imageName: "ic_pouvoirs_publics"),
            (id: 22, name:"Questions sociales et santé", imageName: "ic_questions_sociales_et_sante"),
            (id: 23, name:"Recherche, sciences et techniques", imageName: "ic_recherche_sciences_techniques"),
            (id: 24, name:"Sécurité sociale", imageName: "ic_securite_sociale"),
            (id: 25, name:"Société", imageName: "ic_societe"),
            (id: 26, name:"Sports", imageName: "ic_sport"),
            (id: 27, name:"Traités et conventions", imageName: "ic_traites_conventions"),
            (id: 28, name:"Transports", imageName: "ic_transport"),
            (id: 29, name:"Travail", imageName: "ic_travail"),
            (id: 30, name:"Union européenne", imageName: "ic_europe"),
            (id: 31, name:"Politique générale", imageName: "ic_politique_generale")
            ]
        
        let asyncExpectation = expectation(description: "timelineEvents")
        var retrievedEvents = [TimelineEvent]()
        
        self.testsHelper.timelineThemesApi.timeline(forDeputy: 1, page: 0).subscribe(onNext: { events in
            asyncExpectation.fulfill()
            retrievedEvents = events
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            
            var index = 0
            
            for event in retrievedEvents {
                XCTAssert(event.theme.type.rawValue == themesToTest[index].id)
                XCTAssert(event.theme.type.imageName == themesToTest[index].imageName)
                XCTAssert(event.theme.name == themesToTest[index].name)
                
                index = index + 1
            }
            
        }
        
    }
}

