//
//  BaseTests.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 03/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest
import RxTest
import RxSwift

class BaseTests: XCTestCase {

    let disposeBag = DisposeBag()
    let scheduler: ConcurrentDispatchQueueScheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    var testSheduler: TestScheduler!
    let testsHelper = TestHelper()
    
    override func setUp() {
        super.setUp()

        self.testSheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        
        self.testsHelper.cleanDatabase()
        
        super.tearDown()
    }
}
