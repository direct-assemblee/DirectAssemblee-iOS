//
//  MockApi.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 03/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift
import Alamofire

class MockApi: MockableApi {
    
    // MARK: - Private helpers
    
    func fakeJsonResponse(forUrl url:String) -> Any? {
        
        if url.contains("/deputies") {
            return self.fakeJsonResponse(forFileName: "deputies_gps")
        } else if url.contains("/deputy") {
            return self.fakeJsonResponse(forFileName: "details_deputy")
        } else if url.contains("/timeline") {
            return self.fakeJsonResponse(forFileName: "timeline_deputy")
        } else if url.contains("/alldeputies") {
            return self.fakeJsonResponse(forFileName: "all_deputies")
        } else if url.contains("/votes") {
            return self.fakeJsonResponse(forFileName: "ballot_deputies_votes")
        } else if url.contains("/features") {
            return self.fakeJsonResponse(forFileName: "features")
        } else if url.contains("subscribe") || url.contains("unsubscribe") {
            return ""
        } else if url.contains("https://api-adresse.data.gouv.fr/search/") {
            return self.fakeJsonResponse(forFileName: "places")
        } else {
            return nil
        }
    }
    
    
}
