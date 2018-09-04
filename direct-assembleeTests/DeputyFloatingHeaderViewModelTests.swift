//
//  DeputyFloatingHeaderViewModelTests.swift
//  direct-assembleeTests
//
//  Created by COUDSI Julien on 01/11/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest

@testable import direct_assemblee


class DeputyFloatingHeaderViewModelTests: BaseTests {
    
    //MARK: - Header height
    
    func testFloatingHeaderShouldBeMaxAtInit() {
        
        let deputyTimelineViewModel = DeputyTimelineViewModel()
        let deputyFloatingHeaderViewModel = DeputyFloatingHeaderViewModel(deputy: self.testsHelper.deputy(), contentViewModel: deputyTimelineViewModel, api: self.testsHelper.deputyDetailsApi, database: self.testsHelper.database)
        
        deputyTimelineViewModel.listScrollOffset.onNext(-Constants.Sizes.deputyHeaderCardMaxHeight)
        
        XCTAssert(deputyFloatingHeaderViewModel.deputyHeaderCardHeight.value == Constants.Sizes.deputyHeaderCardMaxHeight)
        
    }
    
    func testFloatingHeaderShouldReduceHeightWhenUserScrollsToBottomUntilSomePoint() {
        
        let deputyTimelineViewModel = DeputyTimelineViewModel()
        let deputyFloatingHeaderViewModel = DeputyFloatingHeaderViewModel(deputy: self.testsHelper.deputy(), contentViewModel: deputyTimelineViewModel, api: self.testsHelper.deputyDetailsApi, database: self.testsHelper.database)
        
        deputyTimelineViewModel.listScrollOffset.onNext(-Constants.Sizes.deputyHeaderCardMaxHeight)
        var headerHeight = deputyFloatingHeaderViewModel.deputyHeaderCardHeight.value
        
        for i in (Int(Constants.Sizes.deputyHeaderCardMinHeight)...Int(Constants.Sizes.deputyHeaderCardMaxHeight)).reversed() {
            deputyTimelineViewModel.listScrollOffset.onNext(CGFloat(i * -1))
            XCTAssert(deputyFloatingHeaderViewModel.deputyHeaderCardHeight.value == headerHeight)
            headerHeight = headerHeight - 1
        }
        
    }

    func testFloatingHeaderShouldStayMinWhenUserContinueToScrollsToBottom() {
        
        let deputyTimelineViewModel = DeputyTimelineViewModel()
        let deputyFloatingHeaderViewModel = DeputyFloatingHeaderViewModel(deputy: self.testsHelper.deputy(), contentViewModel: deputyTimelineViewModel, api: self.testsHelper.deputyDetailsApi, database: self.testsHelper.database)
        
        deputyTimelineViewModel.listScrollOffset.onNext(-Constants.Sizes.deputyHeaderCardMaxHeight)
        
        for i in -Int(Constants.Sizes.deputyHeaderCardMinHeight)...600 {
          deputyTimelineViewModel.listScrollOffset.onNext(CGFloat(i))
          XCTAssert(deputyFloatingHeaderViewModel.deputyHeaderCardHeight.value == Constants.Sizes.deputyHeaderCardMinHeight)
        }

    }
    
    func testFloatingHeaderShouldStayMinWhenScrollsToTopUnderSomePoint() {
        
        let deputyTimelineViewModel = DeputyTimelineViewModel()
        let deputyFloatingHeaderViewModel = DeputyFloatingHeaderViewModel(deputy: self.testsHelper.deputy(), contentViewModel: deputyTimelineViewModel, api: self.testsHelper.deputyDetailsApi, database: self.testsHelper.database)
        
        deputyTimelineViewModel.listScrollOffset.onNext(-Constants.Sizes.deputyHeaderCardMaxHeight)
        deputyTimelineViewModel.listScrollOffset.onNext(400)
        
        for i in (-Int(Constants.Sizes.deputyHeaderCardMinHeight)...400).reversed() {
            deputyTimelineViewModel.listScrollOffset.onNext(CGFloat(i))
            XCTAssert(deputyFloatingHeaderViewModel.deputyHeaderCardHeight.value == Constants.Sizes.deputyHeaderCardMinHeight)
        }
    }
    
    func testFloatingHeaderShouldIncreaseHeightWhenScrollsToTopFromSomePoint() {
        
        let deputyTimelineViewModel = DeputyTimelineViewModel()
        let deputyFloatingHeaderViewModel = DeputyFloatingHeaderViewModel(deputy: self.testsHelper.deputy(), contentViewModel: deputyTimelineViewModel, api: self.testsHelper.deputyDetailsApi, database: self.testsHelper.database)
        
        deputyTimelineViewModel.listScrollOffset.onNext(-Constants.Sizes.deputyHeaderCardMaxHeight)
        deputyTimelineViewModel.listScrollOffset.onNext(-Constants.Sizes.deputyHeaderCardMinHeight)
        
        var headerHeight = deputyFloatingHeaderViewModel.deputyHeaderCardHeight.value
        
        for i in Int(Constants.Sizes.deputyHeaderCardMinHeight)...Int(Constants.Sizes.deputyHeaderCardMaxHeight) {
            deputyTimelineViewModel.listScrollOffset.onNext(CGFloat(i * -1))
            XCTAssert(deputyFloatingHeaderViewModel.deputyHeaderCardHeight.value == headerHeight)
            headerHeight = headerHeight + 1
        }
    }
    

}
