//
//  Constants.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 03/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import UIKit

struct Constants {
    
    struct Api {
        static let allDeputiesPath = "/alldeputies"
        static let deputyByGpsPath = "/deputies"
        static let deputyDetailsPath = "/deputy"
        static let deputyTimelinePath = "/timeline"
        static let subscribePath = "/subscribe?deputyId=X"
        static let unsubscribePath = "/unsubscribe?deputyId=X"
        static let ballotDeputiesVotesPath = "/votes"
        static let activityRatesByGroupPath = "/activityRates"
    }
    
    struct Web {
        static let faqPath = "/pages/faq/content.html"
    }
    
    struct Key {
        static let kErrorDescription = "errorDescription"
        static let kBaseUrl = "baseUrl"
        static let kBaseApiUrl = "baseApiUrl"
    }
    
    struct ServicesUrl {
        static let placesUrl = "https://api-adresse.data.gouv.fr/search/"
    }
    
    struct Color {
        
        static let blueColorCode = "427AA1"
        static let whiteColorCode = "FFFFFF"
        static let greenColorCode = "2E7D32"
        static let redColorCode = "DA2C38"
        static let grayColorCode = "808080"
        static let yellowColorCode = "F9A825"
        static let orangeColorCode = "EF6C00"
        static let blueLightColorCode = "74A9d2"
        static let blackColorCode = "000000"
    }
    
    struct Image {
        static let deputyPhotoPlaceholderName = "no_photo_placeholder"
    }
    
    struct TimelineEventExtraInfoKey {
        static let date = "date"
        static let description = "description"
        static let commissionName = "commissionName"
        static let commissionTime = "commissionTime"
        static let lawMotives = "lawMotives"
        static let lawMotivesTitle = "lawMotivesTitle"
        static let lawMotivesText = "lawMotivesText"
    }
    
    struct Sizes {
        static let deputyHeaderCardMaxHeight:CGFloat = 180
        static let deputyHeaderCardMinHeight:CGFloat = 50
    }
    
    struct Config {
        struct Files {
            static let fabricApiKey = "fabric.apikey"
            static let apiUrlDev = "api.url.dev"
        }
        
    }
}
