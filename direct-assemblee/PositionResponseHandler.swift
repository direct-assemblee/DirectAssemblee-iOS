//
//  PositionResponseHandler.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 19/07/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import SwiftyJSON

struct PositionResponseHandler {
    
    static func positions(fromJson json:JSON) -> [Position] {
        
        var positions = [Position]()
        let positionsJsonArray = json.arrayValue
        
        for positionJson in positionsJsonArray {
            
            let position = Position()
            
            position.name = positionJson["name"].stringValue
            let instances = positionJson["instances"].arrayValue.map({$0.stringValue})
            position.instances.append(objectsIn: instances.makeIterator())
            
            positions.append(position)
        }
        
        return positions
    }
}
