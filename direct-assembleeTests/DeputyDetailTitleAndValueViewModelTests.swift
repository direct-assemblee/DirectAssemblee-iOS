//
//  DeputyInfoViewModelTests.swift
//  direct-assembleeTests
//
//  Created by COUDSI Julien on 15/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest
import RxSwift

@testable import direct_assemblee

class DeputyDetailTitleAndValueViewModelTests: BaseTests {
    
    func testViewModelShouldBeCorrectlyFilledWithModel() {
        
        let viewModel = DeputyDetailTitleAndValueViewModel(titleText:"Age", valueText:"50 ans")
        
        XCTAssertEqual(viewModel.titleText.value, "Age")
        XCTAssertEqual(viewModel.valueText.value, "50 ans")
    }
    
}
