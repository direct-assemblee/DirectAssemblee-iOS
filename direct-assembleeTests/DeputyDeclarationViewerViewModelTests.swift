//
//  DeputyDeclarationViewerViewModelTests.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 06/07/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import XCTest
import RxSwift

@testable import direct_assemblee

class DeputyDeclarationViewerViewModelTests: BaseTests {

    func testViewModelShouldBeOkWhenFileIsDownloaded() {

        let downloadedFileUrlExpectation = expectation(description: "downloadFile")
        var retrieveredDownloadedFileUrl:URL?

        let deputy = self.testsHelper.deputy()
        let declaration = deputy.declarations[0]
        let deputyDeclarationViewerViewModel = DeputyDeclarationViewerViewModel(api: TestsApi(testMode: CommonTestMode.download), declaration: declaration)
        
        deputyDeclarationViewerViewModel.downloadedFileUrl.subscribe(onNext: { url in
            downloadedFileUrlExpectation.fulfill()
            retrieveredDownloadedFileUrl = url
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(deputyDeclarationViewerViewModel.titleText.value == "Déclaration 1")
            XCTAssert(deputyDeclarationViewerViewModel.dateText.value == "Déposée le 10/06/2017")
            XCTAssert(retrieveredDownloadedFileUrl?.absoluteString == "file://localhost/Users/blop/Documents/")
            XCTAssert(deputyDeclarationViewerViewModel.isLoadingViewHidden.value == true)
            XCTAssert(deputyDeclarationViewerViewModel.isShareButtonEnabled.value == true)
            XCTAssert(deputyDeclarationViewerViewModel.isWebviewHidden.value == false)
            XCTAssert(deputyDeclarationViewerViewModel.isErrorViewHidden.value == true)
        }
    }
    
    func testViewModelShouldBeOkWhenDownloadError() {
        
        let downloadedFileUrlExpectation = expectation(description: "downloadFile")
   
        let deputy = self.testsHelper.deputy()
        let declaration = deputy.declarations[0]
        let deputyDeclarationViewerViewModel = DeputyDeclarationViewerViewModel(api: TestsApi(testMode: CommonTestMode.error), declaration: declaration)
        
        var retrievedError:Error?
        deputyDeclarationViewerViewModel.downloadedFileUrl.subscribe(onError: { error in
            retrievedError = error
            downloadedFileUrlExpectation.fulfill()
        }).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 4) { error in
            XCTAssert(deputyDeclarationViewerViewModel.titleText.value == "Déclaration 1")
            XCTAssert(deputyDeclarationViewerViewModel.dateText.value == "Déposée le 10/06/2017")
            XCTAssert(deputyDeclarationViewerViewModel.isLoadingViewHidden.value == true)
            XCTAssert(deputyDeclarationViewerViewModel.isShareButtonEnabled.value == false)
            XCTAssert(deputyDeclarationViewerViewModel.isWebviewHidden.value == true)
            XCTAssert(deputyDeclarationViewerViewModel.isErrorViewHidden.value == false)
            XCTAssert(deputyDeclarationViewerViewModel.errorText.value == String(describing: retrievedError!))
        }
    }
    
    func testViewModelShouldBeOkWhenLoading() {

        let deputy = self.testsHelper.deputy()
        let declaration = deputy.declarations[0]
        let deputyDeclarationViewerViewModel = DeputyDeclarationViewerViewModel(api: TestsApi(testMode: CommonTestMode.download), declaration: declaration)

        XCTAssert(deputyDeclarationViewerViewModel.titleText.value == "Déclaration 1")
        XCTAssert(deputyDeclarationViewerViewModel.dateText.value == "Déposée le 10/06/2017")
        XCTAssert(deputyDeclarationViewerViewModel.isLoadingViewHidden.value == false)
        XCTAssert(deputyDeclarationViewerViewModel.isShareButtonEnabled.value == false)
        XCTAssert(deputyDeclarationViewerViewModel.isWebviewHidden.value == true)
        XCTAssert(deputyDeclarationViewerViewModel.isErrorViewHidden.value == true)
    }

}
