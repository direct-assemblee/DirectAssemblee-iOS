//
//  ThemeManager.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 21/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import UIKit

struct ThemeManager {
    
    static func applyGlobalAppareance() {
        
        UINavigationBar.appearance().barTintColor = UIColor(hex: Constants.Color.blueColorCode)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor(hex: Constants.Color.whiteColorCode), NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16, weight: .semibold)]
        UISearchBar.appearance().barTintColor = UIColor(hex: Constants.Color.blueColorCode)
    }
    
}
