//
//  DeputyDeclarationViewModelTests.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 19/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest
import RxSwift

@testable import direct_assemblee

class DeputyDeclarationViewModelTests: BaseTests {
    
    func testViewModelShouldBeCorrectlyFilledWithModel() {
        
        let deputy = self.testsHelper.deputy()
        let declaration = deputy.declarations[0]
        let deputyDeclarationViewModel = DeputyDeclarationViewModel(declaration: declaration)
        
        XCTAssert(deputyDeclarationViewModel.titleText.value == "Déclaration 1")
        XCTAssert(deputyDeclarationViewModel.valueText.value == "Déposée le 10/06/2017")
        XCTAssert(deputyDeclarationViewModel.url == "http://www.url1.org")
    }
}
