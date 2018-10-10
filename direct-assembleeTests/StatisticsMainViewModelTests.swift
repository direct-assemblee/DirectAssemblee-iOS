//
//  StatisticsMainViewModelTests.swift
//  direct-assembleeTests
//
//  Created by COUDSI Julien on 10/10/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//

import XCTest

@testable import direct_assemblee

class StatisticsMainViewModelTests: BaseTests {
    
    func testViewModelShouldBeOk() {
        
        let viewModel = StatisticsMainViewModel()
        
        XCTAssertEqual(viewModel.title, R.string.localizable.synthesis())
    }

    
}
