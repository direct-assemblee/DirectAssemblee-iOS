//
//  Deputy.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 02/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RealmSwift
import Realm

class Deputy:Object {
    
    @objc dynamic var id:Int = 0
    @objc dynamic var firstName:String = ""
    @objc dynamic var lastName:String = ""
    @objc dynamic var department:Department?
    let districtNumber = RealmOptional<Int>()
    @objc dynamic var parliamentGroup:String?
    @objc dynamic var commission:String?
    @objc dynamic var phone:String?
    @objc dynamic var email:String?
    @objc dynamic var job:String?
    @objc dynamic var currentMandateStartDate:Date?
    @objc dynamic var photoUrl:String?
    @objc dynamic var photoData:Data?
    let parliamentAgeInMonths = RealmOptional<Int>()
    let activityRate = RealmOptional<Int>()
    let salary = RealmOptional<Float>()
    var declarations = List<Declaration>()
    let seatNumber = RealmOptional<Int>()
    let age = RealmOptional<Int>()
    var otherCurrentMandates = List<String>()
    var roles = List<Role>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    static func fromSummary(_ deputySummary: DeputySummary) -> Deputy {
        
        let deputy = Deputy()
        
        deputy.id = deputySummary.id
        deputy.firstName = deputySummary.firstName
        deputy.lastName = deputySummary.lastName
        
        if let id = deputySummary.department?.id,
            let code = deputySummary.department?.code,
            let name = deputySummary.department?.name {
            
            deputy.department = Department()
            deputy.department?.id = id
            deputy.department?.code = code
            deputy.department?.name = name
        }

        deputy.districtNumber.value = deputySummary.districtNumber
        deputy.parliamentGroup = deputySummary.parliamentGroup
        deputy.seatNumber.value = deputySummary.seatNumber
        deputy.activityRate.value = deputySummary.activityRate
        deputy.photoUrl = deputySummary.photoUrl
        deputy.photoData  = deputySummary.photoData
        
        return deputy
    }
}
