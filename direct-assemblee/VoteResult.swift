//
//  VoteResult.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 08/08/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation

enum VoteResult:String {
    case agree
    case against
    case blank
    case missing
    case nonVoting
    case signed
    case notSigned
    
    init(string: String) {
        switch string {
        case "for":
            self = .agree
        case "against":
            self = .against
        case "blank":
            self = .blank
        case "missing":
            self = .missing
        case "non-voting":
            self = .nonVoting
        case "signed":
            self = .signed
        case "not_signed":
            self = .notSigned
        default:
            self = .missing
        }
    }
    
    var text:String {
        
        switch self {
            
        case .agree:
            return R.string.localizable.vote_result_for()
        case .signed:
            return R.string.localizable.timeline_event_motion_of_censure_signed()
        case .against:
            return R.string.localizable.vote_result_against()
        case .notSigned:
            return R.string.localizable.timeline_event_motion_of_censure_not_signed()
        case .missing:
            return R.string.localizable.vote_result_missing()
        case .nonVoting:
            return R.string.localizable.vote_result_non_voting()
        case .blank:
            return R.string.localizable.vote_result_blank()
        }
    }
    
    var imageName:String {
        
        switch self {
        case .missing:
            return R.image.icon_missing_deputy.name
        default:
            return R.image.icon_deputy.name
        }
    }
    
    var colorCode:String {
        
        switch self {
            
        case .agree, .signed:
            return Constants.Color.greenColorCode
        case .against, .notSigned:
            return Constants.Color.redColorCode
        case .missing:
            return Constants.Color.orangeColorCode
        case .nonVoting:
            return Constants.Color.yellowColorCode
        case .blank:
            return Constants.Color.grayColorCode
        }
    }
    
}
