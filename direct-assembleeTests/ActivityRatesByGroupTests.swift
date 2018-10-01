//
//  ActivityTest.swift
//  direct-assembleeTests
//
//  Created by COUDSI Julien on 01/10/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//

import XCTest

@testable import direct_assemblee

class ActivityRatesByGroupTests: BaseTests {
    
    func testActivityRatesByGroupFromWebServiceShouldBeOk() {
        
        let asyncExpectation = expectation(description: "expectation")
        var activities = [Activity]()
        
        self.testsHelper.activityRatesByGroup.activityRatesByGroup().subscribe(onNext: { result in
            asyncExpectation.fulfill()
            activities = result
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssertEqual(activities.count, 8)
            XCTAssertEqual(activities[0].activityRate, 19)
            XCTAssertEqual(activities[0].parliamentGroup.id, 6)
            XCTAssertEqual(activities[0].parliamentGroup.name, "La France insoumise")
        }
        
    }
    
    
}
