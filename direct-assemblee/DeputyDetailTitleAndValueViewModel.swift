//
//  DeputyDetailTitleAndValueViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 15/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift

class DeputyDetailTitleAndValueViewModel: BaseViewModel, DeputyDetail {
    
    var titleText:Variable<String>
    var valueText:Variable<String>
    var cellIdentifier = R.reuseIdentifier.deputyDetailTitleAndValueTableViewCell.identifier
    var isSelectable = false
    var level = 0
    
    init(titleText:String, valueText:String) {
        
        self.titleText = Variable<String>(titleText)
        self.valueText = Variable<String>(valueText)
        
        super.init()
    }
    
}
