//
//  DeputiesListViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 12/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift

class DeputiesListViewModel: BaseViewModel {
    
    private var deputies = [DeputySummary]()
    var isScrollingEnabled = true
    var deputiesSummariesViewModels = Variable<[DeputySummaryViewModel]>([])
    
    init(deputies:[DeputySummary]) {
        self.deputies = deputies
        super.init()
        self.configure()
    }
    
    func refresh(deputies:[DeputySummary]) {
        self.deputies = deputies
        self.configure()
    }
    
    // MARK: - Configuration
    
    private func configure() {
        
        var deputiesSummariesViewModels = [DeputySummaryViewModel]()
        
        for deputy in self.deputies {
            deputiesSummariesViewModels.append(DeputySummaryViewModel(deputy: deputy))
        }
        
        self.deputiesSummariesViewModels.value = deputiesSummariesViewModels
    }
}
