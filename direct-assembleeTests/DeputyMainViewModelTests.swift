//
//  DeputyTimelineViewModelTests.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 08/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest
import RxSwift

@testable import direct_assemblee

class DeputyMainViewModelTests: BaseTests {

    override func setUp() {
        super.setUp()
        
        self.testsHelper.saveDeputy()
    }
    
    
    func testViewModelShouldInitializeCorrectChildViewModel() {
        
        let testExpectation = expectation(description: "expectation")
        
        let deputyTestViewModel = DeputyMainViewModel(api: self.testsHelper.deputyDetailsApi, database: self.testsHelper.database)
        
        var childViewModel:DeputyFloatingHeaderViewModel?
        
        deputyTestViewModel.childViewModel.subscribe(onNext: { viewModel in
                childViewModel = viewModel
                testExpectation.fulfill()
            }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 1) { error in
            XCTAssert(childViewModel?.contentViewModel is DeputyTimelineViewModel)
        }
        
    }
    
    func testViewModelAfterLoadingDataShouldBeOk() {
        
        let deputyTestViewModel = DeputyMainViewModel(api: self.testsHelper.timelineApi, database: self.testsHelper.database)
        deputyTestViewModel.loadAll()
        
        XCTAssert(deputyTestViewModel.isErrorToastHidden.value == true)
    }
    
    func testViewModelAfterLoadingDataWithErrorShouldBeOk() {
        
        let deputyTestViewModel = DeputyMainViewModel(api: self.testsHelper.errorApi, database: self.testsHelper.database)
        deputyTestViewModel.loadAll()

        XCTAssert(deputyTestViewModel.isErrorToastHidden.value == true)
    }
    
    // MARK: - Pull to refresh
    
    func testViewModelAfterLoadingWithPullToRefreshDataShouldBeOk() {
        
        let deputyTestViewModel = DeputyMainViewModel(api: self.testsHelper.timelineApi, database: self.testsHelper.database)
        deputyTestViewModel.refreshAll()
        
        XCTAssert(deputyTestViewModel.isErrorToastHidden.value == true)
    }
    
    
    func testViewModelAfterPullToRefreshWithErrorDataShouldBeOk() {
        
        let deputyTestViewModel = DeputyMainViewModel(api: self.testsHelper.errorApi, database: self.testsHelper.database)
        deputyTestViewModel.refreshAll()
        
        XCTAssert(deputyTestViewModel.isErrorToastHidden.value == false)
        XCTAssert(deputyTestViewModel.errorToastText.value == R.string.localizable.error_timeline_events())
    }
    


}
