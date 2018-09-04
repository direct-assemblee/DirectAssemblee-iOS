//
//  Declaration.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 06/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RealmSwift

class Declaration: Object {
    
    @objc dynamic var title:String = ""
    @objc dynamic var date:Date = Date()
    @objc dynamic var url:String = ""
    @objc dynamic var deputy:Deputy!
}
