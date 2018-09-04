//
//  MultipleDeputyChoiceViewController.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 03/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxSwift
import RxCocoa

class MultipleDeputiesFoundViewController: BaseViewController, SearchDeputyResult, BindableType {
    
    @IBOutlet weak var multipleDeputiesFoundLabel: UILabel!
    @IBOutlet weak var possibleDeputiesLabel: UILabel!
    @IBOutlet weak var deputiesListContainerView: UIView!
    @IBOutlet weak var deputiesListContainerViewHeightConstraint: NSLayoutConstraint!
    
    private var deputiesListViewController:DeputiesListViewController!
    var viewModel:MultipleDeputiesFoundViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.removeSearchControllerFromNavigationStack()
        self.setupColors()
        self.bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.deputiesListContainerViewHeightConstraint.constant = self.deputiesListViewController.deputiesTableView.contentSize.height
        self.view.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController) {
            TaggageManager.sendEvent(eventName: "back_from_many_deputies_found")
        }
    }
    
    // MARK: - Style
    
    private func setupColors() {
        self.multipleDeputiesFoundLabel.textColor = UIColor(hex: Constants.Color.blackColorCode)
        self.possibleDeputiesLabel.textColor = UIColor(hex: Constants.Color.blackColorCode)
    }
    
    //MARK: - Binding
    
    func bindViewModel() {
        self.viewModel.multipleDeputiesFoundText.asObservable().bind(to: self.multipleDeputiesFoundLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.possibleDeputiesText.asObservable().bind(to: self.possibleDeputiesLabel.rx.text).disposed(by: self.disposeBag)
        
        self.deputiesListViewController.didSelectViewModel.subscribe(onNext: { [weak self] viewModel in
            self?.viewModel.didSelectDeputy.onNext(.followConfirmed(viewModel))
        }).disposed(by: self.disposeBag)
        
        self.viewModel.didSelectDeputy
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] status in
                switch status {
                case .followStarts:
                    self?.view.window?.rootViewController = TabBarViewController()
                default:
                    break
                }
            }).disposed(by: self.disposeBag)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.deputiesListViewController = segue.destination as! DeputiesListViewController
        self.deputiesListViewController.viewModel = self.viewModel.deputiesListViewModel
    }
}
