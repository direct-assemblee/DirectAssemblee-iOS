//
//  BallotVotes.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 28/05/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation

struct BallotDeputiesVotes {
    
    var forDeputies: [DeputySummary]
    var againstDeputies: [DeputySummary]
    var blankDeputies: [DeputySummary]
    var missingDeputies: [DeputySummary]
    var nonVotingDeputies: [DeputySummary]
    
    init(forDeputies: [DeputySummary], againstDeputies: [DeputySummary], blankDeputies: [DeputySummary], missingDeputies: [DeputySummary], nonVotingDeputies: [DeputySummary]) {
        self.forDeputies = forDeputies
        self.againstDeputies = againstDeputies
        self.blankDeputies = blankDeputies
        self.missingDeputies = missingDeputies
        self.nonVotingDeputies = nonVotingDeputies
    }
    
    mutating func sortInAlphabeticalOrder() {
        self.againstDeputies = self.sort(self.againstDeputies)
        self.forDeputies = self.sort(self.forDeputies)
        self.blankDeputies = self.sort(self.blankDeputies)
        self.missingDeputies = self.sort(self.missingDeputies)
        self.nonVotingDeputies = self.sort(self.nonVotingDeputies)
    }
    
    private func sort(_ deputies: [DeputySummary]) -> [DeputySummary] {
        return deputies.sorted(by: { deputy1, deputy2 -> Bool in
            return "\(deputy1.firstName) \(deputy1.lastName)" < "\(deputy2.firstName) \(deputy2.lastName)"
        })
    }
}
