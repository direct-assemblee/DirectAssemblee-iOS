//
//  BaseViewController.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 03/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxSwift
import SafariServices

protocol BindableType {
    
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
}


class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    
    deinit {
        log.debug(type(of: self))
    }

    override func viewDidLoad() {

        self.setupNavigationBar()
        self.setupCustomBackButtonIfNeeded()
        self.setupCustomNavigationViewIfNeeded()
        self.setupTopBackgroundViewIfNeeded()
    }
    
    // MARK: - Navigation items
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor(hex: Constants.Color.whiteColorCode)
    }
    
    //TODO A dégager pour utilisation d'une UINavigationBar native partout
    func setupCustomBackButtonIfNeeded() {
        
        guard let backButton = self.backButton else {
            return
        }
        
        backButton.setImage(backButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.imageView?.tintColor = UIColor(hex: Constants.Color.whiteColorCode)
        backButton.tintColor =  UIColor(hex: Constants.Color.whiteColorCode)
    }
    
    //TODO A dégager pour utilisation d'une UINavigationBar native partout
    func setupCustomNavigationViewIfNeeded() {
        
        guard let navigationView = self.navigationView else {
            return
        }
        
        navigationView.backgroundColor = UIColor(hex: Constants.Color.blueColorCode)
    }
    
    //TODO A dégager pour utilisation d'une UINavigationBar native partout
    func setupTopBackgroundViewIfNeeded() {
        
        guard let backgroundView = self.backgroundView else {
            return
        }
        
        backgroundView.backgroundColor = UIColor(hex: Constants.Color.blueColorCode)
    }
    
    //MARK: - Helpers
    
    func openWebUrl(url: URL) {
        
        if #available(iOS 10.0, *) {
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.preferredBarTintColor = UIColor(hex: Constants.Color.blueColorCode)
            safariViewController.preferredControlTintColor = UIColor(hex: Constants.Color.whiteColorCode)
            self.present(safariViewController, animated: true, completion: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    //MARK: - Actions
    
    @IBAction func onBackTouched(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onCloseTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

protocol SearchDeputyResult {
    func removeSearchControllerFromNavigationStack()
}

extension SearchDeputyResult where Self: UIViewController {
    
    func removeSearchControllerFromNavigationStack() {
        
        guard let viewControllers = self.navigationController?.viewControllers else {
            return
        }
        
        for case let viewController as SearchDeputyViewController in viewControllers {
            self.navigationController?.viewControllers.remove(at: viewControllers.index(of: viewController)!)
        }
    }
}


