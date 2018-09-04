//
//  DeputyFloatingHeaderViewModel.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 24/10/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxSwift
import FirebaseMessaging
import RealmSwift

enum HeaderMode {
    case master
    case detail
}

class DeputyFloatingHeaderViewModel: BaseViewModel {
    
    private var deputy:Deputy
    private var api:Api
    private var database:Realm
    private var previousEventsScrollOffset: CGFloat = Constants.Sizes.deputyHeaderCardMaxHeight
    private var headerMode = HeaderMode.master
    private var deputyMode = DeputyMode.follow
    
    var contentViewModel:FloatingHeaderContentViewModel
    var deputyHeaderCardViewModel:DeputyHeaderCardViewModel
    var deputyHeaderCardHeight = Variable<CGFloat>(Constants.Sizes.deputyHeaderCardMaxHeight)

    init(deputy:Deputy, contentViewModel:FloatingHeaderContentViewModel, api:Api, database:Realm, headerMode:HeaderMode = .master, deputyMode: DeputyMode = .follow) {
        
        self.deputy = deputy
        self.api = api
        self.database = database
        self.contentViewModel = contentViewModel
        self.headerMode = headerMode
        self.deputyMode = deputyMode
        self.deputyHeaderCardViewModel = DeputyHeaderCardViewModel(api: api, database: database, deputyMode: deputyMode)
        
        super.init()
        
        self.configureDeputyHeaderHeight()
        self.configureUserActions()
        
        self.refreshHeaderWithDeputy(deputy)

    }
    
    func refreshHeaderWithDeputy(_ deputy: Deputy) {
        self.deputyHeaderCardViewModel.display(deputy: deputy, headerMode: self.headerMode)
        self.deputy = deputy
    }
    
    func disableNeededProfileActions() {
        self.deputyHeaderCardViewModel.disableDeputyProfileAccess()
    }
    
    func enableNeededProfileActions() {
        self.deputyHeaderCardViewModel.enableDeputyProfileAccess()
    }
    
    //MARK: - Configuration
    
    private func configureDeputyHeaderHeight() {
        
        self.contentViewModel.listScrollOffset.subscribe(onNext: { [weak self] offset in
            self?.deputyHeaderCardHeight.value = self?.getDeputyCardHeight(fromScrollOffset: offset) ?? Constants.Sizes.deputyHeaderCardMaxHeight
        }).disposed(by: self.disposeBag)
    }
    
    private func configureUserActions() {
        self.deputyHeaderCardViewModel.didTapOnReducedHeader.bind(to: self.contentViewModel.didUserWantToScrollToTop).disposed(by: self.disposeBag)
    }


    // MARK: - Deputy Card height
    
    private func isEventsScrollingDown(currentOffset:CGFloat, previousOffset:CGFloat) -> Bool {
        return currentOffset > previousOffset
    }
    
    private func isEventsScrollingUp(currentOffset:CGFloat, previousOffset:CGFloat) -> Bool {
        return currentOffset < previousOffset
    }
    
    private func getDeputyCardHeight(fromScrollOffset offset:CGFloat) -> CGFloat {

        let scrollDiff = abs(offset - self.previousEventsScrollOffset)
        var height = self.deputyHeaderCardHeight.value
        
        //Down
        if self.deputyHeaderCardHeight.value > Constants.Sizes.deputyHeaderCardMinHeight
            && self.isEventsScrollingDown(currentOffset: offset, previousOffset: self.previousEventsScrollOffset) {
            
            height = max(Constants.Sizes.deputyHeaderCardMinHeight, self.deputyHeaderCardHeight.value - scrollDiff)
            
            //Up
        } else if self.isEventsScrollingUp(currentOffset: offset, previousOffset: self.previousEventsScrollOffset)
            && offset > -Constants.Sizes.deputyHeaderCardMaxHeight
            && offset < -Constants.Sizes.deputyHeaderCardMinHeight
            && self.deputyHeaderCardHeight.value < Constants.Sizes.deputyHeaderCardMaxHeight  {
            
            height = min(Constants.Sizes.deputyHeaderCardMaxHeight, self.deputyHeaderCardHeight.value + scrollDiff)
            
            //Up pull to refresh
        } else if self.isEventsScrollingUp(currentOffset: offset, previousOffset: self.previousEventsScrollOffset)
            && offset <= -Constants.Sizes.deputyHeaderCardMaxHeight {
            
            height = min(abs(offset), self.deputyHeaderCardHeight.value + scrollDiff)
        }
        
        self.previousEventsScrollOffset = offset
        
        return height
    }
    
}
