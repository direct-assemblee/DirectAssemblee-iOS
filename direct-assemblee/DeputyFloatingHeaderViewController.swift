//
//  DeputyFloatingHeaderViewController.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 24/10/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxSwift

class DeputyFloatingHeaderViewController: BaseViewController, BindableType {

    @IBOutlet weak var headerCardBackgroundView: UIView!
    @IBOutlet weak var deputyHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var deputyHeaderContainerView: UIView!
    
    private var deputyHeaderViewController:DeputyHeaderCardViewController!
    private var contentViewController:BaseViewController!
    
    typealias ViewModelType = DeputyFloatingHeaderViewModel
    var viewModel:DeputyFloatingHeaderViewModel!
    
    // MARK: - Initializers
    
    static func instanciateWithContentViewController(_ contentViewController: BaseViewController) -> DeputyFloatingHeaderViewController {

        let viewController = R.storyboard.deputy().instantiateViewController(withIdentifier: R.storyboard.deputy.deputyFloatingHeaderViewController.identifier) as! DeputyFloatingHeaderViewController
        viewController.contentViewController = contentViewController
    
        return viewController
    }
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupColors()
        self.setupContentViewController()
        self.bindViewModel()
    }
    
    // MARK: - Style
    
    func setupColors() {
        self.headerCardBackgroundView.backgroundColor = UIColor(hex: Constants.Color.blueColorCode)
    }
    
    // MARK: - Binding
    
    func bindViewModel() {
        self.bindDeputyHeaderHeight()
    }
    
    private func bindDeputyHeaderHeight() {
        
        self.viewModel.deputyHeaderCardHeight.asObservable().subscribe(onNext: { [weak self] height in
            self?.deputyHeaderHeightConstraint.constant = height
        }).disposed(by: self.disposeBag)
    }
    


    // MARK: - Child controllers management
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == R.segue.deputyFloatingHeaderViewController.deputyCardSegue.identifier {
            self.deputyHeaderViewController = segue.destination as! DeputyHeaderCardViewController
            self.deputyHeaderViewController.viewModel = self.viewModel.deputyHeaderCardViewModel
        }
    }
    
    private func setupContentViewController() {
        self.add(childViewController: self.contentViewController, inView: self.contentContainerView)
    }
 
}
