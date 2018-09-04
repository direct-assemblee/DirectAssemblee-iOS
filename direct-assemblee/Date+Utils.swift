//
//  Date+Utils.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 03/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation

extension Date {

    static func from(string: String) -> Date? {
        return Date.from(string: string, withFormat: nil)
    }
    
    static func from(string: String, withFormat format: String?) -> Date? {
        
        let dateFormatter = DateFormatter()
        
        if let format = format {
            dateFormatter.dateFormat = format
        } else {
            dateFormatter.dateFormat = "dd/MM/yyyy"
        }
        
        
        guard let date = dateFormatter.date(from: string) else {
            return nil
        }
        
        return date
    }
    
    func toString(withFormat format: String, withLocale locale:String = "fr") -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: locale)
        
        return dateFormatter.string(from: self)
    }
    
}
