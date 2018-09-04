//
//  DeputiesListViewModelTests.swift
//  direct-assembleeTests
//
//  Created by COUDSI Julien on 13/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest
import RxSwift

@testable import direct_assemblee

class DeputiesListViewModelTests: BaseTests {
    
    func testViewModelWithDeputiesShouldBeOk() {
        
        let deputiesListViewModel = DeputiesListViewModel(deputies: [
            self.testsHelper.deputySummary(),
            self.testsHelper.deputySummary(),
            self.testsHelper.deputySummary()
            ])
        
        XCTAssert(deputiesListViewModel.deputiesSummariesViewModels.value.count == 3)
    }
    
    func testViewModelWithoutDeputiesShouldBeOk() {
        
        let deputiesListViewModel = DeputiesListViewModel(deputies: [])
        
        XCTAssert(deputiesListViewModel.deputiesSummariesViewModels.value.count == 0)
    }
    
}
