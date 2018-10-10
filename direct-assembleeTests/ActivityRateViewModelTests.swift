//
//  ActivityRateViewModelTests.swift
//  direct-assembleeTests
//
//  Created by COUDSI Julien on 02/10/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//

import XCTest

@testable import direct_assemblee

class ActivityRateViewModelTests: BaseTests {
    
    func testViewModelShouldBeFilledCorrectlyWithModel() {
        
        let parliamentGroup = ParliamentGroup(id: 1, name: "Blop")
        let activityRate = ActivityRate(parliamentGroup: parliamentGroup, activityRate: 40)
        let viewModel = ActivityRateViewModel(activityRate: activityRate)
        
        XCTAssertEqual(viewModel.activityRateValue.value, 0.4)
        XCTAssertEqual(viewModel.activityRateValueText.value, "40 %")
        XCTAssertEqual(viewModel.parliamentGroupName.value, "Blop")
    }
}
