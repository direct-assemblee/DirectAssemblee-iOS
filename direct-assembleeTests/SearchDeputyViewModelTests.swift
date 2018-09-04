//
//  SearchDeputyViewModelTests.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 06/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest
import RxSwift
import CoreLocation

@testable import direct_assemblee

class SearchDeputyViewModelTests: BaseTests {

    func testSearchDeputyViewModelShouldBeOkWithOneDeputy() {
        
        let searchDeputyViewModel = SearchDeputyViewModel(api: self.testsHelper.oneDeputyListApi, database:self.testsHelper.database, userCoordinates: CLLocationCoordinate2D())
        
        let asyncExpectation = expectation(description: "searchDeputyViewModel")
        
        searchDeputyViewModel.didSelectDeputy.subscribe(onNext: { status in
            switch status {
            case .followStarts:
                asyncExpectation.fulfill()
            default:
                break
            }
            
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(try! searchDeputyViewModel.processingText.value() == R.string.localizable.onboarding_search_deputy())
            XCTAssert(searchDeputyViewModel.isLoadingViewHidden.value == false)
        }
        
    }
    
    func testSearchDeputyViewModelShouldBeOkWithTwoDeputies() {
        
        let searchDeputyViewModel = SearchDeputyViewModel(api: self.testsHelper.twoDeputiesListApi, database:self.testsHelper.database, userCoordinates: CLLocationCoordinate2D())
        
        let asyncExpectation = expectation(description: "searchDeputyViewModel")
        var retrievedViewModel:MultipleDeputiesFoundViewModel!
        
        searchDeputyViewModel.multipleDeputyFoundViewModel.subscribe(onNext: { viewModel in
            asyncExpectation.fulfill()
            retrievedViewModel = viewModel
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(retrievedViewModel.deputiesListViewModel.deputiesSummariesViewModels.value.count > 1)
        }

    }
    
    func testSearchDeputyViewModelShouldBeOkWithSearchDeputyWebServiceError() {
        
        let searchDeputyViewModel = SearchDeputyViewModel(api: self.testsHelper.errorApi, database:self.testsHelper.database, userCoordinates: CLLocationCoordinate2D())
        
        XCTAssert(try! searchDeputyViewModel.processingText.value() == R.string.localizable.error_deputies_list())
        XCTAssert(searchDeputyViewModel.isLoadingViewHidden.value == true)
        
    }
    
    
}
