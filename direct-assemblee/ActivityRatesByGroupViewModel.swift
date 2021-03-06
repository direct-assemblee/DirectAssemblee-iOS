//
//  ActivityRatesByGroupViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 02/10/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ActivityRatesByGroupViewModel: BaseViewModel {

    private var api: Api
    
    var state: BehaviorRelay<State> = BehaviorRelay(value: .loading)
    var activitiesRatesViewModels = PublishSubject<[ActivityRateViewModel]>()
    
    init(api: Api) {
        self.api = api
        
        super.init()
        
        self.loadActivityRates()
    }
    
    // MARK: - Configure
    
    func loadActivityRates() {
        
        self.state.accept(.loading)
        
        self.api.activityRates().subscribe(onNext: { [weak self] activitiesRates in
            let activitiesRatesViewModels = activitiesRates.map({  ActivityRateViewModel(activityRate: $0) })
            self?.state.accept(.loaded)
            self?.activitiesRatesViewModels.onNext(activitiesRatesViewModels)
            }, onError: { [weak self] error in
                self?.state.accept(.error(error: error as! DAError))
        }).disposed(by: self.disposeBag)
        
    }
    
}
