//
//  RolesResponseHandler.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 19/07/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import SwiftyJSON

struct RoleResponseHandler {
    
    static func roles(fromJson json:JSON) -> [Role] {
        
        var roles = [Role]()
        let rolesJsonArray = json.arrayValue
        
        for roleJson in rolesJsonArray {
            
            let role = Role()
            
            role.instanceType = roleJson["instanceType"].stringValue
            let positions = PositionResponseHandler.positions(fromJson: roleJson["positions"])
            role.positions.append(objectsIn: positions.makeIterator())
            
            roles.append(role)
        }
        
        return roles
    }
}
