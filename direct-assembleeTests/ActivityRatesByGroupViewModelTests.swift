//
//  ActivityRatesByGroupViewModelTests.swift
//  direct-assembleeTests
//
//  Created by COUDSI Julien on 02/10/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import direct_assemblee

class ActivityRatesByGroupViewModelTests: BaseTests {
    
    func testViewModelShouldBeInitializedCorrectlyWithStateLoaded() {

        let viewModel = ActivityRatesByGroupViewModel(api: self.testsHelper.activityRatesByGroupApi)
        let stateObservable = viewModel.state.subscribeOn(scheduler)

        let result = try! stateObservable.skip(1).toBlocking(timeout: 4.0).first()
        
        XCTAssertEqual(result, State.loaded)
    }
    
    func testViewModelShouldBeInitializedCorrectlyWithStateError() {
        
        let viewModel = ActivityRatesByGroupViewModel(api: self.testsHelper.errorApi)
        let stateObservable = viewModel.state.subscribeOn(scheduler)
        
        let result = try! stateObservable.toBlocking(timeout: 4.0).first()
        
        let error = DAError(message: R.string.localizable.error_retry())
        XCTAssertEqual(result, State.error(error: error))
    }
    
    func testViewModelShouldBeInitializedCorrectlyWithActivityRatesWhenStateLoaded() {
        
        let viewModel = ActivityRatesByGroupViewModel(api: self.testsHelper.activityRatesByGroupApi)

        let activitiesRatesObservable = viewModel.activitiesRatesViewModels.subscribeOn(scheduler)
        
        let result = try! activitiesRatesObservable.toBlocking(timeout: 4.0).first()
        
        XCTAssertEqual(result?.count, 8)
    }
    
    
}
