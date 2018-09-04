//
//  DeputySummaryTest.swift
//  direct-assembleeTests
//
//  Created by COUDSI Julien on 14/03/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest

@testable import direct_assemblee

class DeputySummaryTest: BaseTests {
    
    func testNumberOfDeputiesFromGpsCoordinateWebServiceShouldBeOk() {
        
        let asyncExpectation = expectation(description: "deputyGps")
        var retrievedDeputies = [DeputySummary]()
        
        self.testsHelper.twoDeputiesListApi.deputies(forLatitude: 43.608619, andLongitude: 3.879903).subscribe(onNext: { deputies in
            asyncExpectation.fulfill()
            retrievedDeputies = deputies
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedDeputies.count == 2)
        }
    }
    
    func testDeputyFromGpsWebServiceShouldBeBuiltCorrectly() {
        
        let asyncExpectation = expectation(description: "deputyGps")
        var deputy:DeputySummary? = nil
        
        self.testsHelper.twoDeputiesListApi.deputies(forLatitude: 43.608619, andLongitude: 3.879903).subscribe(onNext: { deputies in
            asyncExpectation.fulfill()
            deputy = deputies[0]
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(deputy?.id == 120)
            XCTAssert(deputy?.firstName == "Xavier")
            XCTAssert(deputy?.lastName == "Breton")
            XCTAssert(deputy?.parliamentGroup == "Les Républicains")
            XCTAssert(deputy?.department?.id == 20)
            XCTAssert(deputy?.department?.code == "2a")
            XCTAssert(deputy?.department?.name == "Corse-du-Sud")
            XCTAssert(deputy?.photoUrl == "http://www2.assemblee-nationale.fr/static/tribun/14/photos/330008.jpg")
        }
    }
    
    func testDeputiesFromAllDeputiesWebServiceShouldBeBuiltCorrectly() {
        
        let asyncExpectation = expectation(description: "allDeputies")
        var retrievedDeputies = [DeputySummary]()
        
        self.testsHelper.allDeputiesListApi.allDeputies().subscribe(onNext: { deputies in
            asyncExpectation.fulfill()
            retrievedDeputies = deputies
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedDeputies.count == 571)
            XCTAssert(retrievedDeputies[0].id == 721876)
            XCTAssert(retrievedDeputies[0].firstName == "Adrien")
            XCTAssert(retrievedDeputies[0].lastName == "Morenas")
            XCTAssert(retrievedDeputies[0].parliamentGroup == "La République en Marche")
            XCTAssert(retrievedDeputies[0].seatNumber == 571)
            XCTAssert(retrievedDeputies[0].activityRate == 38)
            XCTAssert(retrievedDeputies[0].department?.id == 85)
            XCTAssert(retrievedDeputies[0].department?.code == "84")
            XCTAssert(retrievedDeputies[0].department?.name == "Vaucluse")
            XCTAssert(retrievedDeputies[0].districtNumber == 3)
            XCTAssert(retrievedDeputies[0].photoUrl == "http://www2.assemblee-nationale.fr/static/tribun/15/photos/721876.jpg")
        }
    }
    
}
