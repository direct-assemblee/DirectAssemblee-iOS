//
//  PlaceTest.swift
//  direct-assembleeTests
//
//  Created by Julien Coudsi on 26/06/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest

@testable import direct_assemblee

class PlaceTest: BaseTests {
    
    func testPlacesFromWebServiceShouldBeOk() {
        
        let asyncExpectation = expectation(description: "expectation")
        var places = [Place]()
        
        self.testsHelper.places.places(forText: "test").subscribe(onNext: { result in
            asyncExpectation.fulfill()
            places = result
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssertEqual(places.count, 5)
            XCTAssertEqual(places[0].name, "15 Rue Foch")
            XCTAssertEqual(places[0].postCode, "97490")
            XCTAssertEqual(places[0].city, "Saint-Denis")
            XCTAssertEqual(places[0].coordinates!.latitude, -20.901806)
            XCTAssertEqual(places[0].coordinates!.longitude, 55.493449)
        }
        
    }
    
}
