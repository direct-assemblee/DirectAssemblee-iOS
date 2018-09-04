//
//  BallotVotesResponseHandler.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 28/05/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import SwiftyJSON

struct BallotDeputiesVotesResponseHandler {
    
    static func ballotDeputiesVotes(fromJson json:Any) -> BallotDeputiesVotes {
        
        let votes = JSON(json)
        
        guard let forDeputiesJson = votes["for"].array,
            let againstDeputiesJson = votes["against"].array,
            let blankDeputiesJson = votes["blank"].array,
            let missingDeputiesJson = votes["missing"].array,
            let noVotingDeputiesJson = votes["nonVoting"].array else {
                
                return BallotDeputiesVotes(forDeputies: [],
                                           againstDeputies: [],
                                           blankDeputies: [],
                                           missingDeputies: [],
                                           nonVotingDeputies: [])
        }
        
        let ballotDeputiesVotes = BallotDeputiesVotes(forDeputies: DeputySummaryResponseHandler.deputies(fromJson: forDeputiesJson),
                                                      againstDeputies:  DeputySummaryResponseHandler.deputies(fromJson: againstDeputiesJson),
                                                      blankDeputies: DeputySummaryResponseHandler.deputies(fromJson: blankDeputiesJson),
                                                      missingDeputies: DeputySummaryResponseHandler.deputies(fromJson: missingDeputiesJson),
                                                      nonVotingDeputies: DeputySummaryResponseHandler.deputies(fromJson: noVotingDeputiesJson))
        
        return ballotDeputiesVotes
    }
    
}
