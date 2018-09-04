//
//  PlaceViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 10/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift
import CoreLocation

class PlaceViewModel: BaseViewModel {
    
    var place:Place
    
    var addressText:Variable<String>
    var gpsCoordinates = Observable<CLLocationCoordinate2D?>.empty()
    
    required init(place:Place) {
        self.place = place
        self.addressText = Variable<String>("\(place.name), \(place.postCode), \(place.city)")
        super.init()
    }
    
}
