//
//  NoDeputyDeclarationViewModelTests.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 04/07/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest
import RxSwift

@testable import direct_assemblee

class DeputyDetailSingleValueViewModelTests: BaseTests {
    
    func testViewModelShouldBeCorrectlyFilled() {
        
        let deputyDeclarationViewModel = DeputyDetailSingleValueViewModel(valueText: "Jean-Mi")
        
        XCTAssertEqual(deputyDeclarationViewModel.valueText.value, "Jean-Mi")
    }
}
