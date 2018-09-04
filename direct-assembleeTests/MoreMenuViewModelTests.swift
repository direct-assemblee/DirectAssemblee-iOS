//
//  MoreMenuViewModelTests.swift
//  direct-assembleeTests
//
//  Created by Julien Coudsi on 23/04/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest
import RxSwift
import RxTest

@testable import direct_assemblee

class MoreMenuViewModelTests: BaseTests {
    
    enum Expectations {
        static let expectedDeputyCountAfterExitSuccessfully: Int = 0
        static let expectedDeputyCountAfterExitFailed: Int = 1
    }

    
    // MARK: - Exit deputy
    
    func testExitDeputyStatusShouldBeAskConfirmationWhenUserSelectItInMenu() {
        
        let expectedEvents: [Recorded<Event<ExitDeputyStatus>>] = [
            next(0, ExitDeputyStatus.askConfirmation)
        ]
        
        let observer = self.testSheduler.createObserver(ExitDeputyStatus.self)
        
        let viewModel = MoreMenuViewModel(database:self.testsHelper.database, api:self.testsHelper.emptyApi)
        viewModel.exitDeputyStatus.subscribe(observer).disposed(by: self.disposeBag)
        viewModel.didSelectItem.onNext(IndexPath(row: MoreMenuItems.changeDeputy.rawValue, section: 0))
        
        self.testSheduler.start()
        
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    func testDeputyShouldRemovedFromPreferencesWhenExitIsFinishedSuccessfully() {

        try! self.testsHelper.database.save(deputy: self.testsHelper.deputy()).toBlocking().first()
        let viewModel = MoreMenuViewModel(database:self.testsHelper.database, api:self.testsHelper.emptyApi)
        viewModel.exitDeputyStatus.onNext(.confirmed)
        
        let exitStatusObservable = viewModel.exitDeputyStatus.subscribeOn(scheduler)
        
        do {
            guard let result = try exitStatusObservable.toBlocking(timeout: 4.0).first() else { return }
            let savedDeputiesCount = self.testsHelper.database.objects(Deputy.self).count
            XCTAssertEqual(result, ExitDeputyStatus.success)
            XCTAssertEqual(savedDeputiesCount, Expectations.expectedDeputyCountAfterExitSuccessfully, "Deputy database should be empty")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testDeputyShouldNotRemovedFromPreferencesWhenExitIsFinishedWithError() {
        
        try! self.testsHelper.database.save(deputy: self.testsHelper.deputy()).toBlocking().first()
        let viewModel = MoreMenuViewModel(database:self.testsHelper.database, api:self.testsHelper.errorApi)
        viewModel.exitDeputyStatus.onNext(.confirmed)
        
        let exitStatusObservable = viewModel.exitDeputyStatus.subscribeOn(scheduler)
        
        do {
            guard let result = try exitStatusObservable.toBlocking(timeout: 4.0).first() else { return }
            let savedDeputiesCount = self.testsHelper.database.objects(Deputy.self).count
            XCTAssertEqual(result, ExitDeputyStatus.error(R.string.localizable.error_unsubscribe()))
            XCTAssertEqual(savedDeputiesCount, Expectations.expectedDeputyCountAfterExitFailed, "Deputy database should not be empty")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

}
