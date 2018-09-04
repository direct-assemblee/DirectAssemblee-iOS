//
//  UrlBuilder.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 26/04/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation

enum UrlMode {
    case website
    case api
    
    var baseUrl: String? {
        
        let dict = NSDictionary(contentsOfFile: R.file.settingsPlist.path() ?? "") as! Dictionary<String, AnyObject>
        var apiUrl = dict[Constants.Key.kBaseApiUrl] as! String
        
        if apiUrl == "{DEV_API_URL}" {
            guard let devApiUrlRessourceUrl = Bundle.main.url(forResource: Constants.Config.Files.apiUrlDev, withExtension: nil),
                let devApiUrl = try? String(contentsOf: devApiUrlRessourceUrl, encoding: .utf8) else {
                    return nil
            }
            
            apiUrl = devApiUrl
        }
        
        switch self {
        case .website:
            return dict[Constants.Key.kBaseUrl] as? String
        case .api:
            return apiUrl
        }
    }
}

struct UrlBuilder {
    
    private var urlMode: UrlMode
    
    init (urlMode: UrlMode) {
        self.urlMode = urlMode
    }
    
    static func website() -> UrlBuilder {
        return UrlBuilder(urlMode: .website)
    }
    
    static func api() -> UrlBuilder {
        return UrlBuilder(urlMode: .api)
    }
    
    func buildUrl(path: String) -> String {
        return "\(self.baseUrl())\(path)"
    }
    
    func baseUrl() -> String {
        
        guard let baseUrl = self.urlMode.baseUrl else {
            assertionFailure("No API URL is defined. Check your configuration.")
            return ""
        }
        
        return baseUrl
    }
}
