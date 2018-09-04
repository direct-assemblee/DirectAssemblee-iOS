//
//  DeputiesListViewController.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 04/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxSwift
import RxCocoa

class DeputiesListViewController: BaseViewController, BindableType {
    
    @IBOutlet weak var deputiesTableView: UITableView!
    @IBOutlet weak var emptyPlaceholderView: UIView!
    @IBOutlet weak var emptyPlacerholderLabel: UILabel!
    
    typealias ViewModelType = DeputiesListViewModel
    var viewModel:DeputiesListViewModel!
    
    var didScroll = PublishSubject<Void>()
    var didSelectViewModel = PublishSubject<DeputySummaryViewModel>()
    
    private var allowsSelection: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.deputiesTableView.rowHeight = UITableViewAutomaticDimension
        self.deputiesTableView.estimatedRowHeight = 95
        self.deputiesTableView.allowsSelection = self.allowsSelection
        self.emptyPlacerholderLabel.text =  R.string.localizable.no_result()
        
        self.bindViewModel()
    }
    
    static func instanciate(allowsSelection: Bool = true) -> DeputiesListViewController {
        let vc = R.storyboard.onboarding().instantiateViewController(withIdentifier: R.storyboard.onboarding.deputiesListViewController.identifier) as! DeputiesListViewController
        vc.allowsSelection = allowsSelection
        return vc
    }
    
    // MARK: - BindableType protocol
    
    func bindViewModel() {
        self.bindDeputiesListEvents()
        self.bindDeputiesListData()
    }
    
    private func bindDeputiesListEvents() {
        self.deputiesTableView.isScrollEnabled = self.viewModel.isScrollingEnabled
        self.deputiesTableView.rx.didScroll.bind(to: self.didScroll).disposed(by: self.disposeBag)
        self.deputiesTableView.rx.modelSelected(DeputySummaryViewModel.self).bind(to: self.didSelectViewModel).disposed(by: self.disposeBag)
    }
    
    private func bindDeputiesListData() {
        
        self.viewModel.deputiesSummariesViewModels
            .asDriver()
            .drive(onNext: { [weak self] viewModels in
                self?.emptyPlaceholderView.isHidden = viewModels.count > 0
                self?.deputiesTableView.isHidden = viewModels.count == 0
            }).disposed(by: self.disposeBag)
        
        self.viewModel.deputiesSummariesViewModels
            .asDriver()
            .drive(self.deputiesTableView.rx.items(cellIdentifier: R.reuseIdentifier.deputyTableViewCellIdentifier.identifier, cellType: DeputyTableViewCell.self)) { (index, deputyViewModel, cell) in
                cell.viewModel = deputyViewModel
            }.disposed(by: self.disposeBag)
    }
 
}
