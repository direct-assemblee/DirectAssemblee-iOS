//
//  ActivityRateViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 02/10/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//

import Foundation
import RxCocoa

class ActivityRateViewModel: BaseViewModel {
    
    private var activityRate: ActivityRate
    
    var activityRateValue: BehaviorRelay<String>
    var parliamentGroupName: BehaviorRelay<String>
 
    init(activityRate: ActivityRate) {
        self.activityRate = activityRate
        
        self.activityRateValue = BehaviorRelay(value: String(activityRate.activityRate))
        self.parliamentGroupName = BehaviorRelay(value: activityRate.parliamentGroup.name)
    }
    
}
