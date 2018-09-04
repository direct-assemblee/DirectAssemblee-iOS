 //
 //  DeputyHomeViewModel.swift
 //  direct-assemblee
 //
 //  Created by COUDSI Julien on 06/06/2017.
 //  Copyright © 2018 Direct Assemblée. All rights reserved.
 //
 
 import Foundation
 import RxSwift
 import FirebaseMessaging
 import RealmSwift
 import Reachability
 
 class DeputyMainViewModel: BaseViewModel {
    
    private var api:Api
    private var database:Realm
    private var deputy:Deputy?
    private var deputyMode: DeputyMode = .follow
    
    private var deputyFloatingHeaderViewModel:DeputyFloatingHeaderViewModel?
    private var timelineViewModel = DeputyTimelineViewModel()
    
    private var currentTimelinePage = 0
    private var timelineEvents = [TimelineEvent]()
    private var isDeputyLoaded = PublishSubject<Bool>()
    private var isTimelineLoaded = PublishSubject<Bool>()
    
    private let reachability = Reachability()
    private var isPendingLoadMoreTimelineEvents = false
    
    var isErrorToastHidden = Variable<Bool>(true)
    var errorToastText = Variable<String>("")
    var childViewModel = ReplaySubject<DeputyFloatingHeaderViewModel>.create(bufferSize: 1)
    
    init(api:Api, database:Realm, deputy: Deputy? = nil) {
        
        self.api = api
        self.database = database
        
        super.init()
        
        self.deputyMode = deputy == nil ? .follow : .consult
        self.deputy = deputy ?? self.database.objects(Deputy.self).first

        self.configureChildViewModel()
        self.configureInfiniteScroll()
        self.configureLoadingAllDataObservable()
        self.configureUserEventLoadAll()
        self.configurePullToRefresh()
        self.configureReachability()
        
    }
    
    // MARK: - Configuration
    
    private func configureChildViewModel() {
        
        guard let deputy = self.deputy else {
            return
        }
        
        let deputyFloatingHeaderViewModel = DeputyFloatingHeaderViewModel(deputy: deputy,
                                                                          contentViewModel: self.timelineViewModel,
                                                                          api:self.api,
                                                                          database:self.database,
                                                                          deputyMode: self.deputyMode)
        self.deputyFloatingHeaderViewModel = deputyFloatingHeaderViewModel
        self.childViewModel.onNext(deputyFloatingHeaderViewModel)
        
    }
    
    private func configureUserEventLoadAll() {
        
        self.timelineViewModel.isUserWantsToLoadAll
            .subscribe(onNext: { [weak self] _ in
                self?.loadDeputyDetails()
                self?.loadTimeline()
            }).disposed(by: self.disposeBag)
    }
    
    private func configureLoadingAllDataObservable() {
        
        Observable<Bool>.combineLatest([self.isDeputyLoaded.asObservable(), self.isTimelineLoaded.asObservable()])
            .filter({ loadedStatusElements -> Bool in
                return loadedStatusElements.count > 1 && loadedStatusElements[0] == true && loadedStatusElements[1] == true
            }).subscribe(onNext: { [weak self] isAllDataLoaded in
                self?.switchToEverythingOkState()
            }).disposed(by: self.disposeBag)
    }
    
    private func configureInfiniteScroll() {
        
        self.timelineViewModel.isReadyToLoadMoreEvents.asObservable()
            .filter({ value -> Bool in
                return value == true
            }).subscribe(onNext: { [weak self] _ in
                self?.loadMoreEventsForTimeline()
            }).disposed(by: self.disposeBag)
    }
    
    private func configurePullToRefresh() {
        
        self.timelineViewModel.isPullToRefreshControlDisplayed.asObservable().filter { value  in
            return value == true
            }.subscribe(onNext: { [weak self] _ in
                self?.refreshAll()
            }).disposed(by: self.disposeBag);
    }
    
    private func configureReachability() {
        
        guard let reachability = self.reachability else {
            return
        }
        
        reachability.whenReachable = { [weak self] reachability in
            
            if self?.isPendingLoadMoreTimelineEvents == true {
                self?.loadMoreEventsForTimeline()
                self?.isErrorToastHidden.value = true
                self?.isPendingLoadMoreTimelineEvents = false
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            log.error("Unable to start reachability notifier")
        }
    }
    
    // MARK: - Load
    
    func loadAll() {
        self.loadDeputyDetails()
        self.loadTimeline()
    }
    
    func refreshAll() {
        self.refreshDeputyDetails()
        self.refreshTimeline()
    }
    
    //MARK: - Loading helpers
    
    private func loadDeputyDetails() {
        
        guard let departmentId = self.deputy?.department?.id,
            let districtNumber = self.deputy?.districtNumber.value else {
                return
        }
        
        if let deputy = self.deputy {
            self.deputyFloatingHeaderViewModel?.refreshHeaderWithDeputy(deputy)
        }
        
        self.deputyFloatingHeaderViewModel?.disableNeededProfileActions()
        
        self.api
            .deputyWithPhotoData(forDepartmentId: departmentId, andDistrictNumber: districtNumber)
            .subscribe(onNext: { [weak self] deputy in
                
                self?.isDeputyLoaded.onNext(true)
                self?.isDeputyLoaded.onCompleted()
                self?.deputyFloatingHeaderViewModel?.refreshHeaderWithDeputy(deputy)
                self?.deputyFloatingHeaderViewModel?.enableNeededProfileActions()
                self?.saveDeputy(deputy: deputy)
                
            }).disposed(by: self.disposeBag)
        
    }
    
    private func refreshDeputyDetails() {
        
        guard let departmentId = self.deputy?.department?.id,
            let districtNumber = self.deputy?.districtNumber.value else {
                return
        }
        
        self.api
            .deputyWithPhotoData(forDepartmentId: departmentId, andDistrictNumber: districtNumber)
            .subscribe(onNext: { [weak self] deputy in
                
                self?.deputyFloatingHeaderViewModel?.refreshHeaderWithDeputy(deputy)
                self?.saveDeputy(deputy: deputy)
                
                }, onError: { [weak self] error in
                    
                    self?.switchToErrorState(error:error as! DAError)
                    
            }).disposed(by: self.disposeBag)
    }
    
    private func loadTimeline() {
        
        self.timelineViewModel.displayLoading()
        
        self.currentTimelinePage = 0
        self.timelineEventsObservable().subscribe(onNext: { [weak self]  timelineEvents in
            
            self?.isTimelineLoaded.onNext(true)
            self?.isTimelineLoaded.onCompleted()
            self?.timelineViewModel.displayEvents(timelineEvents: timelineEvents)
            self?.timelineEvents = timelineEvents
            
            }, onError: { [weak self]  error in
                self?.timelineViewModel.displayError(error: error as! DAError)
                
        }).disposed(by: self.disposeBag)
        
    }
    
    private func refreshTimeline() {
        
        self.currentTimelinePage = 0
        self.timelineEventsObservable().subscribe(onNext: { [weak self]  timelineEvents in
            
            self?.switchToEverythingOkState()
            self?.timelineViewModel.displayEvents(timelineEvents: timelineEvents)
            self?.timelineEvents = timelineEvents
            self?.timelineViewModel.areTotalEventsLoaded.value = false
            
            }, onError: { [weak self]  error in
                self?.switchToErrorState(error:error as! DAError)
        }).disposed(by: self.disposeBag)
        
    }
    
    private func loadMoreEventsForTimeline() {
        
        self.currentTimelinePage = self.currentTimelinePage + 1
        
        if let savedDeputy = self.deputy {
            TaggageManager.sendEvent(eventName: "deputy_timeline_load_more", forDeputy: savedDeputy, parameters: ["page": self.currentTimelinePage as NSObject])
        }
        
        self.timelineEventsObservable()
            .subscribe(onNext: { [weak self]  timelineEvents in
                
                self?.switchToEverythingOkState()
                self?.timelineEvents.append(contentsOf: timelineEvents)
                self?.timelineViewModel.displayEvents(timelineEvents: self?.timelineEvents ?? [])
                self?.timelineViewModel.isLoadMoreEventsFinished.value = true
                self?.timelineViewModel.isReadyToLoadMoreEvents.value = false
                self?.timelineViewModel.areTotalEventsLoaded.value = timelineEvents.count > 0 ? false : true
                
                }, onError: { [weak self]  error in
                    self?.manageInfiniteScrollError(error as! DAError)
                    
            }).disposed(by: self.disposeBag)
    }
    
    
    // MARK: - States
    
    private func switchToEverythingOkState() {
        self.isErrorToastHidden.value = true
    }
    
    private func switchToErrorState(error: DAError) {
        self.isErrorToastHidden.value = false
        self.errorToastText.value = error.description
        self.timelineViewModel.isPullToRefreshControlDisplayed.value = false
    }
    
    // MARK: - Private helpers
    
    private func timelineEventsObservable() -> Observable<[TimelineEvent]> {
        
        guard let deputyId = self.deputy?.id else {
            return Observable<[TimelineEvent]>.empty()
        }
        
        return self.api.timeline(forDeputy: deputyId, page: self.currentTimelinePage).share(replay: 1)
    }
    
    private func manageInfiniteScrollError(_ error:DAError) {
        
        self.switchToErrorState(error:error)
        
        if error.code == NSURLErrorNotConnectedToInternet {
            self.isPendingLoadMoreTimelineEvents = true
        } else {
            self.timelineViewModel.isLoadMoreEventsFinished.value = true
            self.timelineViewModel.isReadyToLoadMoreEvents.value = false
        }
    }
    
    private func saveDeputy(deputy: Deputy) {
        self.database.save(deputy: deputy).subscribe().disposed(by: self.disposeBag)
    }
 }
