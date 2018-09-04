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
