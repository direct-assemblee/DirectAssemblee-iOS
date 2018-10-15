//
//  SearchDeputyViewController.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 03/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxSwift
import CoreLocation
import RxCocoa
class SearchDeputyViewController: BaseViewController, BindableType {
    
    @IBOutlet weak var loadingViewContainer: UIView!
    @IBOutlet weak var processingLabel: UILabel!
    
    private var locationManager = CLLocationManager()
    
    typealias ViewModelType = SearchDeputyViewModel
    var viewModel:SearchDeputyViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.viewModel == nil {
            self.viewModel = SearchDeputyViewModel(api: SingletonManager.sharedApiInstance, database:SingletonManager.sharedDatabaseInstance, userCoordinates:nil)
        }
        
        self.loadingViewContainer.addLoadingView()
        
        self.setupColors()
        self.bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController) {
            TaggageManager.sendEvent(eventName: "cancel_search_deputy")
        }
    }
    
    // MARK: - Style
    
    private func setupColors() {
        self.processingLabel.textColor = UIColor(hex: Constants.Color.blackColorCode)
    }
    
    // MARK: - Binding
    
    func bindViewModel() {
        
        self.viewModel.multipleDeputyFoundViewModel
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] viewModel in
                let multipleDeputiesFoundViewController = R.storyboard.onboarding.multipleDeputiesFoundViewController()!
                multipleDeputiesFoundViewController.viewModel = viewModel
                self?.navigationController?.pushViewController(multipleDeputiesFoundViewController, animated: true)
            }).disposed(by: self.disposeBag)
        
        self.viewModel.didSelectDeputy.subscribe(onNext: { [weak self] status in
            switch status {
            case .followStarts:
                self?.view.window?.rootViewController = TabBarViewController()
            default:
                break
            }
        }).disposed(by: self.disposeBag)
        
        self.viewModel.processingText.asDriver(onErrorJustReturn: "").drive(self.processingLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.isLoadingViewHidden.asDriver().drive(self.loadingViewContainer.rx.isHidden).disposed(by: self.disposeBag)
    }
    
    // MARK: - Navigation
    
    func navigateToNextStep(withResultViewModel resultViewModel:BaseViewModel?) {
        
        if let multipleDeputiesFoundViewModel = resultViewModel as? MultipleDeputiesFoundViewModel {
            let multipleDeputiesFoundViewController = R.storyboard.onboarding.multipleDeputiesFoundViewController()!
            multipleDeputiesFoundViewController.viewModel = multipleDeputiesFoundViewModel
            self.navigationController?.pushViewController(multipleDeputiesFoundViewController, animated: true)
        } else {
            
        }
    }
    
}
