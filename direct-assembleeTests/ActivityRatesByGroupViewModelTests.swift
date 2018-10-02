//
//  ActivityRatesByGroupViewModelTests.swift
//  direct-assembleeTests
//
//  Created by COUDSI Julien on 02/10/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//

import XCTest

@testable import direct_assemblee

class ActivityRatesByGroupViewModelTests: BaseTests {
    
    func testViewModelShouldBeInitializedCorrectly() {
        
        let testExpectation = expectation(description: "expectation")
        
        let viewModel = ActivityRatesByGroupViewModel(api: self.testsHelper.activityRatesByGroupApi)
        var retrievedActivityRatesViewModels = [ActivityRateViewModel]()
        
        viewModel.state.subscribe(onNext: { state in
            
            switch state {
            case .loaded(let viewModels):
                retrievedActivityRatesViewModels = viewModels
                testExpectation.fulfill()
            default:
                break
            }
            
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssertEqual(retrievedActivityRatesViewModels.count, 8)
        }
    }
    
}
