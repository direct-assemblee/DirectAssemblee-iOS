//
//  DeputyMainInformation.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 05/07/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift
import RealmSwift

protocol DeputyDetail {
    
    var valueText:Variable<String> { get set }
    var cellIdentifier:String { get set }
    var isSelectable:Bool { get set }
    var level: Int { get set }
}

protocol VoteResultInfo {
    var userDeputyVoteResultText:Variable<String> { get set }
}


protocol FloatingHeaderContentViewModel {
    var listScrollOffset:PublishSubject<CGFloat> { get set }
    var didUserWantToScrollToTop:PublishSubject<Void> { get set }
}


protocol OnboardingFinalStepViewModel: class {
    func finishOnboarding(deputy: DeputySummary, api: Api, database: Realm) -> Observable<Void>
}

extension OnboardingFinalStepViewModel {
    
    func finishOnboarding(deputy: DeputySummary, api: Api, database: Realm) -> Observable<Void> {
        
        let userDeputy = Deputy.fromSummary(deputy)
        
        let finishOnboarding = Observable<Void>.create({ observer in
            
            TaggageManager.sendUserProperty("district", value: String(describing: userDeputy.districtNumber.value))
            TaggageManager.sendUserProperty("parliament_group", value: deputy.parliamentGroup ?? "")
            TaggageManager.sendEvent(eventName: "one_deputy_found", forDeputy: userDeputy)
            
            NotificationsManager.sharedInstance.registerToApns()
            NotificationsManager.sharedInstance.subscribeToPushNotifications(forDeputy: userDeputy, api: api)

            observer.onCompleted()
            
            return Disposables.create()
        })
        
        return Observable.concat(database.save(deputy: userDeputy), finishOnboarding)
    }
}

protocol DeputySearchViewModel {
    func isTextFound(_ searchText: String, inDeputy deputy: DeputySummary) -> Bool
}

extension DeputySearchViewModel {
    
    func isTextFound(_ searchText: String, inDeputy deputy: DeputySummary) -> Bool {
        
        let options: String.CompareOptions = [.caseInsensitive, .diacriticInsensitive]
        
        let searchTextParts = searchText.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ")
        var isEligible = true
        
        for searchTextPart in searchTextParts {
            isEligible = deputy.firstName.range(of: searchTextPart, options: options, range:nil, locale: nil) != nil
                || deputy.lastName.range(of: searchTextPart, options: options, range:nil, locale: nil) != nil
                || (deputy.department?.name ?? "").range(of: searchTextPart, options: options, range:nil, locale: nil) != nil
                || (deputy.parliamentGroup ?? "").range(of: searchTextPart, options: options, range:nil, locale: nil) != nil
                || (deputy.department?.code.lowercased() ?? "").range(of: searchTextPart, options: options, range:nil, locale: nil) != nil
            
            if !isEligible {
                return false
            }
        }
        
        return true
    }
}


