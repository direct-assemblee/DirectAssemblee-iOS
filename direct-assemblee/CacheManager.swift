//
//  CacheManager.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 13/03/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation

struct CacheManager {
    
    static var sharedInstance = CacheManager()
    
    static let allDeputiesCacheKey = "allDeputies"
    
    fileprivate let cache = NSCache<NSString, AnyObject>()
    
    //#MARK: - Cache management
    
    func getData(forKey key: String) -> [AnyObject] {
        
        if let cachedData = self.cache.object(forKey: key as NSString) as? [AnyObject] {
            return cachedData
        } else {
            return []
        }
    }
    
    func update(data: AnyObject, forKey key: String) {
        self.cache.setObject(data, forKey: key as NSString)
    }
    
}
