//
//  Enumerations.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 02/05/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation

enum DeputyMode {
    case follow
    case consult
}

enum SelectDeputyStatus {
    case selected(DeputySummaryViewModel)
    case askFollowConfirm(DeputySummaryViewModel)
    case followConfirmed(DeputySummaryViewModel)
    case followStarts
    case consultationStarts(DeputyMainViewModel)
}


enum State: Equatable {
    case loading
    case loaded
    case error(error: DAError)
    
    static func ==(lhs: State, rhs: State) -> Bool {
        switch (lhs, rhs) {
        case ( .loaded, .loaded), (.loading, .loading):
            return true
            
        case (let .error(error1), let .error(error2)):
            return error1.code == error2.code && error1.description == error2.description
            
        default:
            return false
        }
    }
}
