//
//  DeputySummaryResponseHandler.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 14/03/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import SwiftyJSON

struct DeputySummaryResponseHandler {
    
    static func deputies(fromJson json:Any) -> [DeputySummary] {
        
        var deputies = [DeputySummary]()
        
        guard let deputiesJsonArray = json as? [Any] else {
            return deputies
        }
        
        for deputyJson in deputiesJsonArray {
            
            if let deputy = DeputySummaryResponseHandler.deputy(fromJson: deputyJson) {
                deputies.append(deputy)
            }
        }
        
        return deputies
    }
    
    static func deputy(fromJson json:Any) -> DeputySummary? {
        
        let deputyJsonDictionary = JSON(json)
        
        guard let id = deputyJsonDictionary["id"].int,
            let firstName = deputyJsonDictionary["firstname"].string,
            let lastName = deputyJsonDictionary["lastname"].string,
            let department = DeputyResponseHandler.department(fromJson: deputyJsonDictionary["department"].dictionaryObject ?? [:]),
            let districtNumber = deputyJsonDictionary["district"].int else {
                
                return nil
        }
        
        let deputySummary = DeputySummary(
            id: id,
            firstName: firstName,
            lastName: lastName)
        
        deputySummary.department = department
        deputySummary.districtNumber = districtNumber
        deputySummary.parliamentGroup = deputyJsonDictionary["parliamentGroup"].string
        deputySummary.photoUrl = deputyJsonDictionary["photoUrl"].string
        deputySummary.activityRate = deputyJsonDictionary["activityRate"].int
        deputySummary.seatNumber = deputyJsonDictionary["seatNumber"].int
        
        return deputySummary
        
    }
}
