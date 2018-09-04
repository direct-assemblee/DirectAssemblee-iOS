//
//  SearchDeputyByNameViewModelTests.swift
//  direct-assembleeTests
//
//  Created by Julien on 12/03/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest
import RxSwift
import RxTest

@testable import direct_assemblee

class SearchDeputyInListViewModelTests: BaseTests {
    
    enum Expectations {
        static let expectedDeputyCountAfterFollowSuccessfully: Int = 1
        static let expectedDeputyIdAfterFollowSuccessfully: Int = 1
        static let expectedDeputyCountAfterConsultSuccessfully: Int = 0
    }
    
    func testViewModelShouldBeCorrectlyFilledWhenLoading() {
        
        let viewModel = SearchDeputyInListViewModel(api: self.testsHelper.allDeputiesListApi, database:self.testsHelper.database, deputyMode: .follow)
        
        XCTAssert(viewModel.enterNamePlaceholderText == R.string.localizable.search_all_deputies_placeholder())
        XCTAssert(viewModel.isSearchEnabled.value == false)
        XCTAssert(viewModel.isLoadingViewHidden.value == false)
        XCTAssert(viewModel.isErrorViewHidden.value == true)
        XCTAssert(viewModel.deputiesListViewModel.value == nil)
    }

    func testViewModelShouldBeCorrectlyFilledWithDeputiesList() {
        
        let viewModel = SearchDeputyInListViewModel(api: self.testsHelper.allDeputiesListApi, database:self.testsHelper.database, deputyMode: .follow)
        
        let asyncExpectation = expectation(description: "expectation")
        
        viewModel.deputiesListViewModel.asObservable()
            .filter{ $0 != nil}
            .subscribe(onNext: { _ in
            asyncExpectation.fulfill()
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(viewModel.enterNamePlaceholderText == R.string.localizable.search_all_deputies_placeholder())
            XCTAssert(viewModel.isSearchEnabled.value == true)
            XCTAssert(viewModel.isLoadingViewHidden.value == true)
            XCTAssert(viewModel.isErrorViewHidden.value == true)
            XCTAssert(viewModel.deputiesListViewModel.value != nil)
        }
    }

    
    func testDeputyShouldBeCorrectlySavedInFollowMode() {
        
        let deputy = self.testsHelper.deputySummary()
        let deputySummaryViewModel = DeputySummaryViewModel(deputy: deputy)
     
        let viewModel = SearchDeputyInListViewModel(api: self.testsHelper.oneDeputyListApi, database:self.testsHelper.database, deputyMode: .follow)

        let didSelectDeputyObservable = viewModel.didSelectDeputy.subscribeOn(self.scheduler)
        viewModel.didSelectDeputy.onNext(.followConfirmed(deputySummaryViewModel))
        
        do {
            guard let _ = try didSelectDeputyObservable.toBlocking(timeout: 4.0).first(),
                let deputy = self.testsHelper.database.objects(Deputy.self).first else { return }
            
            let savedDeputiesCount = self.testsHelper.database.objects(Deputy.self).count

            XCTAssertEqual(deputy.id, Expectations.expectedDeputyIdAfterFollowSuccessfully, "Deputy identifier should be correct")
            XCTAssertEqual(savedDeputiesCount, Expectations.expectedDeputyCountAfterFollowSuccessfully, "Deputy database should not be empty")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testDeputyShouldNotBeSavedInConsultMode() {
        
        let viewModel = SearchDeputyInListViewModel(api: self.testsHelper.timelineApi, database:self.testsHelper.database, deputyMode: .consult)
        
        let deputy = self.testsHelper.deputySummary()
        let deputySummaryViewModel = DeputySummaryViewModel(deputy: deputy)
        
        let didSelectDeputyObservable = viewModel.didSelectDeputy.subscribeOn(self.scheduler)
        viewModel.didSelectDeputy.onNext(.selected(deputySummaryViewModel))
        
        do {
            guard let _ = try didSelectDeputyObservable.toBlocking(timeout: 4.0).first() else { return }
            let savedDeputiesCount = self.testsHelper.database.objects(Deputy.self).count
            XCTAssertEqual(savedDeputiesCount, Expectations.expectedDeputyCountAfterConsultSuccessfully, "Deputy database should be empty")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
