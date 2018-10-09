//
//  SearchDeputyInListViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 09/03/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift
import RealmSwift

class SearchDeputyInListViewModel: BaseViewModel, OnboardingFinalStepViewModel, DeputySearchViewModel {
    
    private var api: Api
    private var database: Realm
    private var deputyMode: DeputyMode
    private var deputies = [DeputySummary]()
    
    var title = R.string.localizable.search_a_deputy()
    var enterNamePlaceholderText = R.string.localizable.search_all_deputies_placeholder()
    var searchText = PublishSubject<String>()
    var reloadText = R.string.localizable.reload()
    var isSearchEnabled = Variable<Bool>(false)
    var errorPlaceholderText = Variable<String>("")
    var isLoadingViewHidden = Variable<Bool>(true)
    var isErrorViewHidden = Variable<Bool>(true)
    var deputiesListViewModel = Variable<DeputiesListViewModel?>(nil)
    var didSelectDeputy = PublishSubject<SelectDeputyStatus>()
    
    init(api: Api, database: Realm, deputyMode: DeputyMode) {
        self.api = api
        self.database = database
        self.deputyMode = deputyMode
        super.init()
        
        self.loadDeputies()
        self.configure()
    }
    
    // MARK : - Configure
    
    func loadDeputies() {
        
        self.isLoadingViewHidden.value = false
        self.isErrorViewHidden.value = true
        
        if let cachedDeputies = CacheManager.sharedInstance.getData(forKey: CacheManager.allDeputiesCacheKey) as? [DeputySummary],
            cachedDeputies.count > 0 {
            log.debug("\(cachedDeputies.count) deputies cached")
            self.loadDeputiesFromCache(deputies: cachedDeputies)
        } else {
            log.debug("Deputies list isn't cached")
            self.loadDeputiesFromWebService()
        }
    }
    
    private func loadDeputiesFromCache(deputies: [DeputySummary]) {
        
        self.deputies = deputies
        
        self.getDeputiesViewModels(deputies: deputies).subscribe(onNext: { [weak self] deputiesListViewModel in
            self?.deputiesListViewModel.value = deputiesListViewModel
            self?.isLoadingViewHidden.value = true
            self?.isSearchEnabled.value = true
        }).disposed(by: self.disposeBag)
    }
    
    private func loadDeputiesFromWebService() {
        
        self.api.allDeputies().subscribe(onNext: { [weak self] deputies in
            self?.deputies = deputies
            self?.deputiesListViewModel.value = DeputiesListViewModel(deputies: deputies)
            CacheManager.sharedInstance.update(data: deputies as AnyObject, forKey: CacheManager.allDeputiesCacheKey)
            self?.isSearchEnabled.value = true
            self?.isLoadingViewHidden.value = true
            self?.isErrorViewHidden.value = true
            }, onError: { [weak self] error in
                self?.errorPlaceholderText.value = String(describing: error)
                self?.isLoadingViewHidden.value = true
                self?.isErrorViewHidden.value = false
        }).disposed(by: self.disposeBag)
        
    }
    
    // MARK: - Configuration
    
    private func configure() {
        
        self.searchText
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribe(onNext: { [unowned self] searchText in
                
                let filteredDeputies = searchText.isEmpty ? self.deputies : self.deputies.filter({ [unowned self] deputy -> Bool in
                    return self.isTextFound(searchText, inDeputy: deputy)
                })
                
                self.deputiesListViewModel.value?.refresh(deputies: filteredDeputies)
                
            }).disposed(by: self.disposeBag)
        
        self.didSelectDeputy
            //Eviter une reetrancy anomaly : on dispatche chaque évènement l'un après l'autre
            //En effet, on envoie un nouvel évènement au subject avant que l'observer aie fini de lire l'évènement en cours
            .observeOn(SerialDispatchQueueScheduler.init(qos: .default))
            .subscribe(onNext: { [unowned self] status in
                self.handleSelectDeputyStatus(status)
            }).disposed(by: self.disposeBag)
    }
    
    // MARK: - Helpers
    
    private func getDeputiesViewModels(deputies: [DeputySummary]) -> Observable<DeputiesListViewModel> {
        
        return Observable<DeputiesListViewModel>.create({ observer in
            let deputiesListViewModel = DeputiesListViewModel(deputies: deputies)
            
            observer.onNext(deputiesListViewModel)
            observer.onCompleted()
            
            return Disposables.create()
        }).subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
    }
    
    func handleSelectDeputyStatus(_ status: SelectDeputyStatus) {
        
        switch status {
        case .selected(let viewModel):
            
            if self.deputyMode == .follow {
                self.didSelectDeputy.onNext(.askFollowConfirm(viewModel))
            } else {
                let deputy = Deputy.fromSummary(viewModel.deputy)
                let viewModel = DeputyMainViewModel(api: self.api, database: self.database, deputy: deputy)
                self.didSelectDeputy.onNext(.consultationStarts(viewModel))
            }
        case .followConfirmed(let viewModel):
            
            self.finishOnboarding(deputy: viewModel.deputy, api: self.api, database: self.database).subscribe(onNext: { [weak self] in
                self?.didSelectDeputy.onNext(SelectDeputyStatus.followStarts)
            }).disposed(by: self.disposeBag)
            
        default:
            break
        }
    }
    
}
