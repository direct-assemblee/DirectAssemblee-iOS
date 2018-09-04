//
//  Errors.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 11/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import Rswift
import Crashlytics

class DAError: Error, CustomStringConvertible {
    
    var code:Int
    var description: String

    convenience init(message:String) {
        self.init(error: NSError(domain: "", code: 0, userInfo: nil), message: message)
    }
    
    init(error:Error, message:String) {
    
        if (error as NSError).code == NSURLErrorNotConnectedToInternet {
            self.code = (error as NSError).code
            self.description = R.string.localizable.error_no_internet()
        } else {
            Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["errorInfo": message])
            self.code = 0
            self.description = message
        }
    }
}
