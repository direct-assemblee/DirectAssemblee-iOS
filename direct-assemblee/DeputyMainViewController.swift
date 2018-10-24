//
//  ViewController.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 27/04/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxSwift

class DeputyMainViewController: BaseViewController, BindableType, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var errorToastTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorToastTextLabel: UILabel!
    @IBOutlet weak var errorToastView: UIView!
    @IBOutlet weak var errorTextTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeErrorToastButton: UIButton!
    
    typealias ViewModelType = DeputyMainViewModel
    var viewModel:DeputyMainViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.loadAll()
        
        self.setupColors()
        self.bindViewModel()
        self.configureErrorToast()

    }
    
    static func instanciate(with viewModel: DeputyMainViewModel) -> DeputyMainViewController {
        let viewController = R.storyboard.deputy.deputyMainViewController()!
        viewController.viewModel = viewModel
        return viewController
    }

    // MARK: - Style
    
    private func setupColors() {
        self.errorToastView.backgroundColor = UIColor(hex: Constants.Color.redColorCode)
        self.errorToastTextLabel.textColor = UIColor(hex: Constants.Color.whiteColorCode)
        self.closeErrorToastButton.setImage(self.closeErrorToastButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.closeErrorToastButton.imageView?.tintColor = UIColor(hex: Constants.Color.whiteColorCode)
        
    }
    
    // MARK: - Binding
    
    func bindViewModel() {
        
        self.bindErrorToast()
        self.bindChildViewModel()
    }
    
    private func bindChildViewModel() {
        
        self.viewModel.childViewModel.subscribe(onNext: { [weak self] viewModel in
            self?.setupChildViewControllerWithViewModel(viewModel)
        }).disposed(by: self.disposeBag)
    }
    
    private func bindErrorToast() {
        
        self.viewModel.errorToastText.asDriver().drive(self.errorToastTextLabel.rx.text).disposed(by: self.disposeBag)
        
        self.viewModel.isErrorToastHidden
            .asDriver()
            .drive(onNext: { [weak self] isHidden in
                
                if isHidden {
                    self?.hideErrorToast()
                } else {
                    self?.showErrorToast()
                }
                
            }).disposed(by: self.disposeBag)
    }

    // MARK: - Errors display
    
    func hideErrorToast() {
        
        self.view.layoutIfNeeded()
        self.errorToastTopConstraint.constant = -94
        
        self.animateToast()
    }
    
    func showErrorToast() {
        
        self.view.layoutIfNeeded()
        self.errorToastTopConstraint.constant = self.isIphoneXOrMore() ? 0 : -24
        
        self.animateToast()
    }
    
    func animateToast() {
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onCloseErrorToastTouch(_ sender: Any) {
        self.hideErrorToast()
    }
    
    // MARK: - Private helpers
    
    private func setupChildViewControllerWithViewModel(_ viewModel:DeputyFloatingHeaderViewModel) {
        
        let deputyTimelineViewController = R.storyboard.deputy().instantiateViewController(withIdentifier: R.storyboard.deputy.deputyTimelineViewController.identifier) as! DeputyTimelineViewController
        deputyTimelineViewController.viewModel = viewModel.contentViewModel as! DeputyTimelineViewModel
    
        let deputyFloatingHeaderViewController = DeputyFloatingHeaderViewController.instanciateWithContentViewController(deputyTimelineViewController)
        deputyFloatingHeaderViewController.viewModel = viewModel
        
        self.add(childViewController: deputyFloatingHeaderViewController, inView: self.view)
    }
    
    private func configureErrorToast() {
        self.view.bringSubview(toFront: self.errorToastView)
    }
    
    private func isIphoneXOrMore() -> Bool {
        return UIScreen.main.nativeBounds.height >= 2436
    }

}

