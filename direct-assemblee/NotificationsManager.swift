//
//  NotificationsManager.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 31/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging
import RxSwift

class NotificationsManager: NSObject, UNUserNotificationCenterDelegate {
    
    var disposeBag = DisposeBag()
    var eventIdFromNotification:Int?
    
    static let sharedInstance = NotificationsManager()
    
    func registerToApns() {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func handleRemoteNotification(_ userInfo:[AnyHashable:Any]) {
        
        UIApplication.shared.keyWindow?.rootViewController = TabBarViewController()
        
        if let eventIdString = userInfo["workId"] as? String, let eventId = Int(eventIdString) {
            self.eventIdFromNotification = eventId
        }
    }
    
    func subscribeToPushNotifications(forDeputy deputy: Deputy, api:Api) {
        
        guard let token = Messaging.messaging().fcmToken else {
            log.error("Unable to retrieve Firebase token")
            return
        }
        
        let deputyId = deputy.id
        
        self.getFirebaseInstanceID().subscribe(onNext: { instanceId in
            
            api.subscribeToPushNotifications(withToken: token, instanceId: instanceId, forDeputyId: deputyId)
                .subscribe(onError: { error in
                    log.error(error)
                })
                .disposed(by: self.disposeBag)
            
        }).disposed(by: self.disposeBag)
        
    }
    
    func unsubscribeToPushNotifications(forDeputy deputy: Deputy, api:Api) -> Observable<Bool> {
        
        guard let token = Messaging.messaging().fcmToken else {
            log.error("Unable to retrieve Firebase token")
            return Observable<Bool>.of(false)
        }
        
        return self.getFirebaseInstanceID().flatMap { instanceId in
            return api.unsubscribeToPushNotifications(withToken: token, instanceId: instanceId, forDeputyId: deputy.id)
        }
    }
    
    func getFirebaseInstanceID() -> Observable<String> {
        
        return Observable<String>.create { observer in
            
            InstanceID.instanceID().getID { instanceId, error in
                
                if let error = error {
                    log.error("Unable to retrieve Firebase instance ID : \(error)")
                    observer.onError(error)
                } else if let instanceId = instanceId {
                    observer.onNext(instanceId)
                    observer.onCompleted()
                } else {
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
}
