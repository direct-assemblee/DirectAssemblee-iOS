//
//  SingletonManager.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 03/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RealmSwift

struct SingletonManager {
    
    static let sharedApiInstance = RealApi()
    static let sharedDatabaseInstance = try! Realm()
}
