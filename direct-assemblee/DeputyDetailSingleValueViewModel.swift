//
//  DeputyDetailSingleValueViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 04/07/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift

class DeputyDetailSingleValueViewModel: BaseViewModel, DeputyDetail {
    
    var valueText:Variable<String>
    var cellIdentifier = R.reuseIdentifier.deputyDetailSingleValueTableViewCell.identifier
    var isSelectable = false
    var level = 0
    
    init(valueText: String) {
        
        self.valueText = Variable<String>(valueText)
        
        super.init()
    }
}
