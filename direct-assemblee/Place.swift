//
//  Place.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 10/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import CoreLocation

struct Place {
    
    var name: String
    var postCode: String
    var city: String
    var coordinates:CLLocationCoordinate2D?
    
    init(name:String, postCode: String, city: String, coordinates:CLLocationCoordinate2D? = nil) {
        self.name = name
        self.postCode = postCode
        self.city = city
        self.coordinates = coordinates
    }
}
