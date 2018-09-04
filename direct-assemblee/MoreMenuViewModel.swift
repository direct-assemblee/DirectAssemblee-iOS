//
//  MoreMenuViewModel.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 16/04/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift
import RxDataSources
import RealmSwift

enum ExitDeputyStatus: Equatable {
    case askConfirmation
    case denied
    case confirmed
    case success
    case error(String)
}

enum MoreMenuItems: Int {
    case share = 0
    case changeDeputy
    case makeDonation
}

struct ShareInformation {
    var text: String
    var url: URL
}

class MoreMenuViewModel: BaseViewModel {
    
    private var database: Realm
    private var api: Api
    private var deputy: Deputy!
    
    var sections = Variable<[SectionModel<String, MoreMenuItemViewModel>]>([])
    var didSelectItem = PublishSubject<IndexPath>()
    var didShare = PublishSubject<ShareInformation>()
    var didDonate = PublishSubject<URL>()
    var exitDeputyStatus = PublishSubject<ExitDeputyStatus>()

    init(database: Realm, api: Api) {
        
        self.database = database
        self.api = api
        self.deputy = self.database.objects(Deputy.self).first
        
        super.init()
        
        self.configureMenuItems()
        self.configureItemsSelection()
    }
    
    // MARK: - Configure
    
    private func configureMenuItems() {
        
        let items: [MoreMenuItemViewModel] = [
            MoreMenuItemViewModel(menuItem: MoreMenuItem(label: R.string.localizable.share(), imageName: "icon_share")),
            MoreMenuItemViewModel(menuItem: MoreMenuItem(label: R.string.localizable.change_deputy(), imageName: "icon_exit")),
            MoreMenuItemViewModel(menuItem: MoreMenuItem(label: R.string.localizable.make_donation(), imageName: "icon_donate"))
        ]
        
        let sections:[SectionModel<String, MoreMenuItemViewModel>] = [
            SectionModel(model: "model", items: items)
        ]
        
        self.sections.value = sections
    }
    
    private func configureItemsSelection() {
        
        self.setupSelectedExitDeputy()

        self.didSelectItem.subscribe(onNext: { [weak self] indexPath in
            if indexPath.row == MoreMenuItems.share.rawValue {
                self?.didSelectShare()
            } else if indexPath.row == MoreMenuItems.changeDeputy.rawValue {
                self?.exitDeputyStatus.onNext(.askConfirmation)
            } else if indexPath.row == MoreMenuItems.makeDonation.rawValue {
                let url = URL(string: "https://www.tipeee.com/direct-assemblee")!
                self?.didDonate.onNext(url)
            }
        }).disposed(by: self.disposeBag)
        
    }
    
    //MARK: - Share
    
    private func didSelectShare() {
        
        guard let activityRate = self.deputy.activityRate.value else {
            return
        }
        
        TaggageManager.sendShareEvent(contentType: "application")
        
        let shareInformation = ShareInformation(
            text:  R.string.localizable.share_default_text("\(String(describing: activityRate)) %"),
            url: URL(string:UrlBuilder.website().baseUrl())!)
        
        self.didShare.onNext(shareInformation)
    }
    
    //MARK: - Change deputy
    
    private func setupSelectedExitDeputy() {
        
        self.exitDeputyStatus.subscribe(onNext: { [unowned self] status in
            
            switch status {
            case .confirmed:
                TaggageManager.sendEvent(eventName: "confirm_change_deputy", forDeputy: self.deputy)
                self.unsubscribe()
            case .denied:
                TaggageManager.sendEvent(eventName: "deny_change_deputy", forDeputy: self.deputy)
            default:
                break
            }
            
        }).disposed(by: self.disposeBag)
    }
    
    private func unsubscribe() {
        
        NotificationsManager.sharedInstance.unsubscribeToPushNotifications(forDeputy:self.deputy, api:self.api)
            .subscribe(onNext: { [unowned self] success  in

                TaggageManager.sendUserProperty("district", value: "")
                TaggageManager.sendUserProperty("parliament_group", value: "")
                
                self.removeDeputyFromPreferences()
                self.exitDeputyStatus.onNext(.success)
                
                }, onError: { [weak self] error in
                    self?.exitDeputyStatus.onNext(.error(String(describing: error)))
            }).disposed(by: self.disposeBag)
        
    }
    
    private func removeDeputyFromPreferences() {
        
        try! self.database.write {
            self.database.deleteAll()
        }
    }
    
}
