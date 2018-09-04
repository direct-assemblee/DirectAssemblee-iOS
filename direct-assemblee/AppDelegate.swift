//
//  AppDelegate.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 27/04/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import XCGLogger
import Firebase
import FirebaseMessaging
import UserNotifications
import Fabric
import Crashlytics
import RxSwift
import RealmSwift
import Alamofire

let log = XCGLogger.default

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    
    var window: UIWindow?
    var disposeBag = DisposeBag()
    var currentNotificationToken:String?
    
    var rootViewController:UIViewController? {
        
        if self.isDeputySavedSuccessfully() {
            return TabBarViewController()
        } else {
            return R.storyboard.onboarding.onboardingNavigationController()
        }
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let cache = URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: nil)
        URLCache.shared = cache
        
        self.configureFirebase()
        self.configureLogging()
        self.migratesRealm()
        
        self.window?.tintColor = UIColor(hex: Constants.Color.blueColorCode)
        
        #if DEBUG
        if let runningTests = ProcessInfo().environment["runningTests"], runningTests == "true" {
            return true
        }
        #endif
        
        ThemeManager.applyGlobalAppareance()
        
        if self.isDeputySavedSuccessfully() {
            NotificationsManager.sharedInstance.registerToApns()
        }
        
        if let remoteNotificationInfo = launchOptions?[.remoteNotification], let notificationUserInfo = remoteNotificationInfo as? [AnyHashable: Any]  {
            NotificationsManager.sharedInstance.handleRemoteNotification(notificationUserInfo)
        }

        #if !DEBUG
            self.setupCrashlytics()
        #endif
        
        self.window?.rootViewController = self.rootViewController
        
        return true
    }
    
    // MARK: - Crashlytics
    
    private func setupCrashlytics() {
        
        guard let fabricApiKeyRessourceUrl = Bundle.main.url(forResource: Constants.Config.Files.fabricApiKey, withExtension: nil),
            let fabricApiKey = try? String(contentsOf: fabricApiKeyRessourceUrl, encoding: .utf8) else {
                return
        }
        
        Crashlytics.start(withAPIKey: fabricApiKey)
        
    }
    
    
    // MARK: - Push notifications
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        log.error("didFailToRegisterForRemoteNotificationsWithError : \(error)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        log.debug("didRegisterForRemoteNotificationsWithDeviceToken : \(token))")
    }
    
    // MARK: - MessagingDelegate
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        
        log.debug("didRefreshRegistrationToken : \(fcmToken))")
        
        if let _ = self.currentNotificationToken,
            let deputy = SingletonManager.sharedDatabaseInstance.objects(Deputy.self).first {
            
            NotificationsManager.sharedInstance.unsubscribeToPushNotifications(
                forDeputy:deputy,
                api:SingletonManager.sharedApiInstance)
                .subscribe(onNext: { _ in }).disposed(by: self.disposeBag)
        }
        
        if let deputy = SingletonManager.sharedDatabaseInstance.objects(Deputy.self).first {
            NotificationsManager.sharedInstance.subscribeToPushNotifications(forDeputy: deputy, api: SingletonManager.sharedApiInstance)
        }
        
        self.currentNotificationToken = fcmToken
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        log.debug("didReceiveRemoteNotification")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        log.debug("didReceiveRemoteNotification")
        
        NotificationsManager.sharedInstance.handleRemoteNotification(userInfo)
        
        completionHandler(.noData)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        log.debug("didReceiveRemoteNotification")
        
        NotificationsManager.sharedInstance.handleRemoteNotification(userInfo)
    }
    
    // MARK: - Helpers
    
    func isDeputySavedSuccessfully() -> Bool {
        return SingletonManager.sharedDatabaseInstance.objects(Deputy.self).count > 0
    }
    
    func configureFirebase() {
        AnalyticsConfiguration.shared().setAnalyticsCollectionEnabled(true)
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }
    
    private func configureLogging() {
        
        #if DEBUG
        log.setup(level: .verbose, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil, fileLevel: .debug)
        #else
        log.setup(level: .none, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil, fileLevel: .severe)
        #endif
    }
    
    private func migratesRealm() {
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 2,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 2) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
    }
}

