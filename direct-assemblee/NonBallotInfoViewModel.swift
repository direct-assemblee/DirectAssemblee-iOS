//
//  NonBallotInfoViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 07/10/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift

class NonBallotInfoViewModel: BaseViewModel {
    
    private var key:String
    private var value:String
    
    var textValue = Variable<String>("")
    var textSize = Variable<Int>(14)
    var isBold = Variable<Bool>(false)
    var isCentered = Variable<Bool>(false)
    
    init(key:String, value:String) {
        
        self.key = key
        self.value = value
        
        super.init()
        
        self.configure()
    }
    
    //MARK: - Configure
    
    private func configure() {
        self.textValue.value = self.value
        
        self.configureStyle()
    }
    
    private func isBold(forKey key:String) -> Bool {
        return [Constants.TimelineEventExtraInfoKey.date, Constants.TimelineEventExtraInfoKey.lawMotivesTitle, Constants.TimelineEventExtraInfoKey.commissionName, Constants.TimelineEventExtraInfoKey.commissionTime].contains(key)
    }
    
    private func isCentered(forKey key:String) -> Bool {
        return [Constants.TimelineEventExtraInfoKey.date, Constants.TimelineEventExtraInfoKey.commissionTime, Constants.TimelineEventExtraInfoKey.commissionName, Constants.TimelineEventExtraInfoKey.lawMotivesTitle].contains(key)
    }
    
    private func configureStyle() {

        self.isBold.value = self.isBold(forKey: self.key)
        self.isCentered.value = self.isCentered(forKey: self.key)
        
        if self.key == Constants.TimelineEventExtraInfoKey.date {
            self.textSize.value = 14
        }

    }
    
}
