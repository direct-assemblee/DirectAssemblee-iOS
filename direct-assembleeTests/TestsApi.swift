//
//  TestsApi.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 03/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift

@testable import direct_assemblee

class TestsApi: MockableApi {
    
    private var testMode: TestMode
    
    init(testMode: TestMode) {
        self.testMode = testMode
    }
    
    func downloadFile(url: String) -> Observable<URL> {
        
        return Observable<URL>.create({ observer in
            
            if let _ = self.fakeJsonResponse(forUrl:url) {
                observer.onNext(URL(string:"file://localhost/Users/blop/Documents/")!)
                observer.onCompleted()
            } else {
                observer.onError(DAError(message: R.string.localizable.error_download()))
            }
            
            return Disposables.create()
        }).delay(2, scheduler: MainScheduler.instance)
    }
    
    func downloadImage(url:String) -> Observable<Data> {
        return Observable<Data>.just(Data())
    }
    
    // MARK: - Private helpers
    
    func fakeJsonResponse(forUrl url:String) -> Any? {
        return self.fakeJsonResponse(forFileName: self.testMode.fileName)
    }
    
    
    
}

