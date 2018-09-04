//
//  PlaceViewModelTests.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 11/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest
import RxSwift
import CoreLocation

@testable import direct_assemblee

class PlaceViewModelTests: BaseTests {
    
    
    func testViewModelShouldBeCorrectlyFilledWithModel() {
        
        let place = Place(name: "15 Rue Foch", postCode: "97490", city: "Saint-Denis", coordinates: CLLocationCoordinate2D(latitude: 40, longitude: 3))
        let placeViewModel = PlaceViewModel(place: place)
 
        XCTAssert(placeViewModel.addressText.value == "15 Rue Foch, 97490, Saint-Denis")
    }
    
}
