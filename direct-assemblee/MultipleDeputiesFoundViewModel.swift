//
//  MultipleDeputiesFoundViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 12/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift
import RealmSwift
import FirebaseMessaging

class MultipleDeputiesFoundViewModel: BaseViewModel, OnboardingFinalStepViewModel {
    
    private var api:Api
    private var database:Realm
    
    var deputiesListViewModel:DeputiesListViewModel
    var multipleDeputiesFoundText:Variable<String>
    var possibleDeputiesText:Variable<String>
    var didSelectDeputy = PublishSubject<SelectDeputyStatus>()
    
    init(api:Api, database:Realm, deputies:[DeputySummary]) {
        
        self.api = api
        self.database = database
        
        self.multipleDeputiesFoundText = Variable<String>(R.string.localizable.onboarding_multiple_deputies_found())
        self.possibleDeputiesText = Variable<String>(R.string.localizable.onboarding_possible_deputies())
        self.deputiesListViewModel = DeputiesListViewModel(deputies: deputies)
        self.deputiesListViewModel.isScrollingEnabled = false
        
        super.init()
        
        self.configureSelectDeputy()
    }
    
    // MARK: - Configuration
    
    private func configureSelectDeputy() {
        
        self.didSelectDeputy
            //Eviter une reetrancy anomaly : on dispatche chaque évènement l'un après l'autre
            //En effet, on envoie un nouvel évènement au subject avant que l'observer aie fini de lire l'évènement en cours
            .observeOn(SerialDispatchQueueScheduler.init(qos: .default))
            .subscribe(onNext: { [weak self] status in
            self?.handleSelectDeputyStatus(status)
        }).disposed(by: self.disposeBag)
        
    }
    
    // MARK: - Helpers
    
    func handleSelectDeputyStatus(_ status: SelectDeputyStatus) {
        
        switch status {
        case .followConfirmed(let viewModel):
            
            self.finishOnboarding(deputy: viewModel.deputy, api: self.api, database: self.database)
                .subscribe(onNext: { [weak self] in
                    self?.didSelectDeputy.onNext(SelectDeputyStatus.followStarts)
                }).disposed(by: self.disposeBag)
            
        default:
            break
        }
    }
}
