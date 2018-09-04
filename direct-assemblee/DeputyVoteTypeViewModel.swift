//
//  DeputyVoteTypeViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 29/05/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift

class DeputyVoteTypeViewModel : BaseViewModel {
    
    var voteTypeLabel: Variable<String>
    
    init(voteTypeLabel: String) {
        
        self.voteTypeLabel = Variable<String>(voteTypeLabel)
        
        super.init()
    }
    
}
