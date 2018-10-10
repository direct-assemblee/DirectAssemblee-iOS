//
//  TestMode.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 28/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation

protocol TestMode {
    var fileName:String { get }
}

enum DeputiesListTestMode: TestMode {
    
    case oneDeputyFoundByGps
    case twoDeputiesFoundByGps
    case allDeputies
    
    var fileName:String {
        
        switch (self) {
        case .oneDeputyFoundByGps:
            return "1_deputy_found_by_gps"
        case .twoDeputiesFoundByGps:
            return "2_deputies_found_by_gps"
        case .allDeputies:
            return "all_deputies"
        }
    }
}

enum DeputyDetailsTestMode: TestMode {
    
    case deputyOk
    
    var fileName:String {
        
        switch (self) {
        case .deputyOk:
            return "details_deputy"
        }
    }
}


enum TimelineTestMode: TestMode {
    
    case timelineOk
    case timelineThemes
    
    var fileName:String {
        
        switch (self) {
        case .timelineOk:
            return "timeline_deputy"
        case .timelineThemes:
            return "timeline_themes"
        }
    }
}

enum BallotDetailsTestMode: TestMode {
    
    case deputiesVotes
    
    var fileName:String {
        
        switch (self) {
        case .deputiesVotes:
            return "ballot_deputies_votes"
        }
    }
}

enum PlacesTestMode: TestMode {
    
    case places
    
    var fileName:String {
        
        switch (self) {
        case .places:
            return "places"
        }
    }
}

enum StatisticsTestMode: TestMode {
    
    case activityRatesByGroup
    
    var fileName:String {
        
        switch (self) {
        case .activityRatesByGroup:
            return "activity_rates"
        }
    }
}

enum CommonTestMode: TestMode {
    
    case error
    case empty
    case download
    
    var fileName: String {
        
        switch (self) {
        case .error:
            return "no_file"
        case .empty:
            return "response_empty"
        case .download:
            return "downloaded_file"
        }
    }
}

