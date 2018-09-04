//
//  Role.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 19/07/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RealmSwift
import Realm

class Role: Object {

    @objc dynamic var instanceType: String?
    var positions = List<Position>()

}
