//
//  BallotDeputiesVotesTests.swift
//  direct-assembleeTests
//
//  Created by Julien Coudsi on 28/05/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest

@testable import direct_assemblee

class BallotDeputiesVotesTests: BaseTests {
    
    func testBallotDeputiesVotesFromGpsWebServiceShouldBeBuiltCorrectly() {
        
        let asyncExpectation = expectation(description: "expectation")
        var ballotDeputiesVotes:BallotDeputiesVotes? = nil

        self.testsHelper.ballotDeputiesVotes.deputiesVotes(forBallotId: 8).subscribe(onNext: { result in
            asyncExpectation.fulfill()
            ballotDeputiesVotes = result
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssertEqual(ballotDeputiesVotes?.forDeputies.count, 13)
            XCTAssertEqual(ballotDeputiesVotes?.againstDeputies.count, 26)
            XCTAssertEqual(ballotDeputiesVotes?.blankDeputies.count, 0)
            XCTAssertEqual(ballotDeputiesVotes?.missingDeputies.count, 536)
            XCTAssertEqual(ballotDeputiesVotes?.nonVotingDeputies.count, 2)
        }
    }

    
}
