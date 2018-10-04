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
    
    var activityRateValueText: BehaviorRelay<String>
    var activityRateValue: BehaviorRelay<Float>
    var parliamentGroupName: BehaviorRelay<String>
 
    init(activityRate: ActivityRate) {
        self.activityRate = activityRate
        
        self.activityRateValueText = BehaviorRelay(value: String("\(activityRate.activityRate) %"))
        self.activityRateValue = BehaviorRelay(value: Float(activityRate.activityRate)/100)
        self.parliamentGroupName = BehaviorRelay(value: activityRate.parliamentGroup.name)
    }
    
}
