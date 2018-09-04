//
//  MoreMenuItemViewModel.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 16/04/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation

class MoreMenuItemViewModel: BaseViewModel {
    
    private var menuItem: MoreMenuItem
    
    var itemImageName: String = ""
    var itemText: String = ""
    
    init(menuItem: MoreMenuItem) {
        self.menuItem = menuItem
        
        super.init()
        
        self.configure()
    }
    
    //MARK: - Configure
    
    private func configure() {
        self.itemText = self.menuItem.label
        self.itemImageName = self.menuItem.imageName
    }
    
}
