//
//  TabBarControllerViewController.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 27/04/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        self.viewControllers = [
            self.getMyDeputyItemViewController(),
            self.getSearchDeputyItemViewController(),
            self.getMainStatisticsItemViewController(),
            self.getFaqItemViewController(),
            self.getMoreMenuItemViewController()
        ]
    }
    
    private func getMyDeputyItemViewController() -> UIViewController {

        let viewModel =  DeputyMainViewModel(api: SingletonManager.sharedApiInstance, database: SingletonManager.sharedDatabaseInstance)
        let myDeputyViewController = DeputyMainViewController.instanciate(with: viewModel)
        
        let myDeputyNavigationController = UINavigationController(rootViewController: myDeputyViewController)
        myDeputyNavigationController.isNavigationBarHidden = true
        
        let myDeputyBarItem = UITabBarItem(title: R.string.localizable.my_deputy(), image: UIImage(named: "icon_deputy"), selectedImage: UIImage(named: "icon_deputy"))
        myDeputyNavigationController.tabBarItem = myDeputyBarItem
        
        return myDeputyNavigationController
    }
    
    private func getSearchDeputyItemViewController() -> UIViewController {
        
        let searchDeputyInListViewController = SearchDeputyInListViewController.instanciateForConsultationMode()
        
        let searchDeputyNavigationController = UINavigationController(rootViewController: searchDeputyInListViewController)
        searchDeputyNavigationController.navigationBar.isTranslucent = false

        let searchDeputyBarItem = UITabBarItem(title: R.string.localizable.search(), image: UIImage(named: "icon_search"), selectedImage: UIImage(named: "icon_search"))
        searchDeputyNavigationController.tabBarItem = searchDeputyBarItem
        
        return searchDeputyNavigationController
    }
    
    private func getMainStatisticsItemViewController() -> UIViewController {
        
        let mainStatisticsViewController = R.storyboard.statistics.statisticsMainViewController()!
        
        let mainStatisticsNavigationController = UINavigationController(rootViewController: mainStatisticsViewController)
        mainStatisticsNavigationController.navigationBar.isTranslucent = false
        
        let mainStatisticsBarItem = UITabBarItem(title: "Statistiques", image: UIImage(named: "ic_politique_generale"), selectedImage: UIImage(named: "icon_faq"))
        mainStatisticsViewController.tabBarItem = mainStatisticsBarItem
        
        return mainStatisticsNavigationController
    }

    
    private func getFaqItemViewController() -> UIViewController {

        let faqViewController = R.storyboard.common.faqViewController()!
        
        let faqNavigationController = UINavigationController(rootViewController: faqViewController)
        faqNavigationController.navigationBar.isTranslucent = false
        
        let faqBarItem = UITabBarItem(title: R.string.localizable.faq_short(), image: UIImage(named: "icon_faq"), selectedImage: UIImage(named: "icon_faq"))
        faqNavigationController.tabBarItem = faqBarItem
        
        return faqNavigationController
    }
    
    private func getMoreMenuItemViewController() -> UIViewController {

        let moreMenuViewController = R.storyboard.common.moreMenuViewController()!
        
        let moreMenuNavigationController = UINavigationController(rootViewController: moreMenuViewController)
        moreMenuNavigationController.navigationBar.isTranslucent = false
        
        let moreMenuBarItem = UITabBarItem(title: R.string.localizable.more(), image: UIImage(named: "icon_more"), selectedImage: UIImage(named: "icon_more"))
        moreMenuNavigationController.tabBarItem = moreMenuBarItem
        
        return moreMenuNavigationController
    }
    
}
