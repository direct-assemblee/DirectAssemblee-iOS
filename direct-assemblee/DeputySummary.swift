//
//  DeputySummary.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 14/03/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation

class DeputySummary {
    
    var id: Int
    var firstName: String
    var lastName: String
    var department: Department?
    var districtNumber: Int?
    var parliamentGroup: String?
    var activityRate: Int?
    var seatNumber: Int?
    var photoUrl: String?
    var photoData: Data?
    
    init(id: Int, firstName: String, lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
}

