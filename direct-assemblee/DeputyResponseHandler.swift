//
//  DeputeResponseHandler.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 03/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import SwiftyJSON
import RealmSwift

struct DeputyResponseHandler {
    
    static func deputies(fromJson json:Any) -> [Deputy] {
        
        var deputies = [Deputy]()
        
        guard let deputiesJsonArray = json as? [Any] else {
                return deputies
        }
        
        for deputyJson in deputiesJsonArray {
            
            if let deputy = DeputyResponseHandler.deputy(fromJson: deputyJson) {
                deputies.append(deputy)
            }
        }
        
        return deputies
    }
    
    static func deputy(fromJson json:Any) -> Deputy? {
        
        let deputyJsonDictionary = JSON(json)

        guard let id = deputyJsonDictionary["id"].int,
            let firstName = deputyJsonDictionary["firstname"].string,
            let lastName = deputyJsonDictionary["lastname"].string,
            let department = DeputyResponseHandler.department(fromJson: deputyJsonDictionary["department"].dictionaryObject ?? [:]),
            let districtNumber = deputyJsonDictionary["district"].int else {
                
                return nil
        }
        
        let deputy = Deputy()
        deputy.id = id
        deputy.firstName = firstName
        deputy.lastName = lastName
        deputy.department = department
        deputy.districtNumber.value = districtNumber
        deputy.parliamentGroup = deputyJsonDictionary["parliamentGroup"].string;
        deputy.commission = deputyJsonDictionary["commission"].string
        deputy.phone = deputyJsonDictionary["phone"].string
        deputy.email = deputyJsonDictionary["email"].string
        deputy.job = deputyJsonDictionary["job"].string
        deputy.currentMandateStartDate =  Date.from(string: ((deputyJsonDictionary["currentMandateStartDate"].string) ?? ""), withFormat: "dd/MM/yyyy")
        deputy.photoUrl = deputyJsonDictionary["photoUrl"].string
        deputy.parliamentAgeInMonths.value = deputyJsonDictionary["parliamentAgeInMonths"].int
        deputy.activityRate.value = deputyJsonDictionary["activityRate"].int
        deputy.salary.value = deputyJsonDictionary["salary"].float
        deputy.seatNumber.value = deputyJsonDictionary["seatNumber"].int
        deputy.age.value = deputyJsonDictionary["age"].int
        
        let otherCurrentMandates = deputyJsonDictionary["otherCurrentMandates"].arrayValue.map({$0.stringValue})
        deputy.otherCurrentMandates.append(objectsIn: otherCurrentMandates.makeIterator())
        
        let declarations = DeclarationResponseHandler.declarations(fromJson: deputyJsonDictionary["declarations"].arrayObject ?? [])
        deputy.declarations.append(objectsIn: declarations.makeIterator())
        declarations.forEach { $0.deputy = deputy }

        let roles = RoleResponseHandler.roles(fromJson: deputyJsonDictionary["roles"])
        deputy.roles.append(objectsIn: roles.makeIterator())
        
        return deputy
    }

    static func department(fromJson json:Any) -> Department? {
        
        let departmentJsonDictionary = JSON(json)
        
        guard let id = departmentJsonDictionary["id"].int,
            let code = departmentJsonDictionary["code"].string,
            let name = departmentJsonDictionary["name"].string else {
                
                return nil
        }
        
        let department = Department()
        department.id = id
        department.code = code
        department.name = name
        
        return department
    }
    
}
