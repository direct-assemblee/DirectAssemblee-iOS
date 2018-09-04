//
//  MultipleDeputiesFoundViewModelTests.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 10/07/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest
import RxSwift

@testable import direct_assemblee

class MultipleDeputiesFoundViewModelTests: BaseTests {
    
    func testViewModelShouldBeCorrectlyFilled() {
        
        let viewModel = MultipleDeputiesFoundViewModel(api:self.testsHelper.emptyApi, database:self.testsHelper.database, deputies: [])
        
        XCTAssert(viewModel.multipleDeputiesFoundText.value == R.string.localizable.onboarding_multiple_deputies_found())
        XCTAssert(viewModel.possibleDeputiesText.value == R.string.localizable.onboarding_possible_deputies())
    }
    
    func testDeputyShouldBeCorrectlySaved() {

        let asyncExpectation = expectation(description: "expectation")
        
        let deputy = self.testsHelper.deputySummary()
        let deputySummaryViewModel = DeputySummaryViewModel(deputy: deputy)
        
        let viewModel = MultipleDeputiesFoundViewModel(api: self.testsHelper.oneDeputyListApi, database:self.testsHelper.database, deputies: [deputy])
        var retrievedDeputy:Deputy?
        
        viewModel.didSelectDeputy.subscribe(onNext: { status in
            switch status {
            case .followStarts:
                asyncExpectation.fulfill()
                retrievedDeputy = self.testsHelper.database.objects(Deputy.self).first
            default:
                break
            }
            
        }).disposed(by: self.disposeBag)
        
        viewModel.didSelectDeputy.onNext(SelectDeputyStatus.followConfirmed(deputySummaryViewModel))

        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedDeputy?.id == 1)
        }

    }
}
