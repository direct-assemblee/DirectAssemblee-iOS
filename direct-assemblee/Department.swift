//
//  Department.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 08/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RealmSwift

class Department: Object {
    
    @objc dynamic var id:Int = 0
    @objc dynamic var code:String = ""
    @objc dynamic var name:String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
