//
//  ActivityRatesByGroupViewController.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 02/10/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ActivityRatesByGroupViewController: BaseViewController, BindableType {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewContainer: UIView!
    
    typealias ViewModelType = ActivityRatesByGroupViewModel
    var viewModel: ActivityRatesByGroupViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 85
        self.tableView.separatorInset = .zero;
        
        self.viewModel = ActivityRatesByGroupViewModel(api: SingletonManager.sharedApiInstance)

        self.bindViewModel()
    }
    
    func bindViewModel() {
        self.bindState()
        self.bindActivitiesRatesList()
    }
    
    private func bindState() {
        
        self.viewModel.state
            .asDriver()
            .drive(onNext: { [weak self] state in
                
                switch state {
                case .loading:
                    self?.tableViewContainer.addLoadingView(backgroundColor: UIColor(hex: Constants.Color.whiteColorCode))
                case .loaded:
                    self?.tableViewContainer.removeLoadingView()
                case .error(let error):
                    self?.tableViewContainer.addPlaceholderView(error: error, onRefresh: { [weak self] in
                        self?.tableViewContainer.removePlaceholderView()
                        self?.viewModel.loadActivityRates()
                    })
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func bindActivitiesRatesList() {
        
        self.viewModel.activitiesRatesViewModels
            .asDriver(onErrorJustReturn: [])
            .drive(self.tableView.rx.items(cellIdentifier: R.reuseIdentifier.activityRateTableViewCell.identifier, cellType: ActivityRateTableViewCell.self)) { (index, viewModel, cell) in
                cell.viewModel = viewModel
            }.disposed(by: self.disposeBag)
    }
    
}
