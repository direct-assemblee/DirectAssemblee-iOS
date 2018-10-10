//
//  SelectAddressViewController.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 03/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxCocoa
import RxSwift

class SearchDeputyByAddressViewController: BaseViewController, BindableType {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    typealias ViewModelType = SearchDeputyByAddressViewModel
    var viewModel:SearchDeputyByAddressViewModel!
    
    private var searchResultsDefaultFooterView:UIView!
    private var searchResultsErrorFooterView:UIView!
    private var searchResultsLoadingFooterView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = SearchDeputyByAddressViewModel(api: SingletonManager.sharedApiInstance)
        
        self.bindViewModel()
        
        self.searchBar.placeholder = self.viewModel.enterAddressPlaceholder
        
        self.searchResultsDefaultFooterView = R.nib.selectAddressFooterView.firstView(owner: self)
        self.searchResultsErrorFooterView = R.nib.selectAddressErrorFooterView.firstView(owner: self)
        self.searchResultsLoadingFooterView = R.nib.selectAddressLoadingFooterView.firstView(owner: self)
        self.searchResultsTableView.tableFooterView = self.searchResultsDefaultFooterView
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController) {
            TaggageManager.sendEvent(eventName: "back_from_select_address")
        }
    }
    
    // MARK: - Binding
    
    func bindViewModel() {
        
        self.bindSearchBarEvents()
        self.bindAddressesListEvents()
        self.bindAddressSelectedEvent()
    }
    
    private func bindSearchBarEvents() {
        
        self.searchBar.rx.text.orEmpty.filter({ text in
            return text.isEmpty
        }).subscribe(onNext: { [weak self] _ in
            self?.viewModel.didClearSearchText.onNext(())
        }).disposed(by: self.disposeBag)
        
        self.searchBar.rx.text.orEmpty
            .debounce(0.4, scheduler: MainScheduler.instance)
            .asObservable().bind(to: self.viewModel.searchPlaceText).disposed(by: self.disposeBag)
    }
    
    private func bindAddressesListEvents() {
        
        self.viewModel.searchPlaceResultsViewModels
            .asDriver(onErrorJustReturn: [])
            .drive(self.searchResultsTableView.rx.items(cellIdentifier: R.reuseIdentifier.placeTableViewCellIdentifier.identifier, cellType: PlaceTableViewCell.self)) { (index, placeViewModel, placeCell) in
                placeCell.viewModel = placeViewModel
            }.disposed(by: self.disposeBag)
        
        self.viewModel.isErrorViewDisplayed
            .asDriver()
            .drive(onNext: { [weak self] isDisplayed in
                
                if isDisplayed {
                    self?.searchResultsTableView.tableFooterView = self?.searchResultsErrorFooterView
                } else {
                   self?.searchResultsTableView.tableFooterView = self?.searchResultsDefaultFooterView
                }
            
        }).disposed(by: self.disposeBag)
        
        self.viewModel.isLoadingViewDisplayed
            .asDriver()
            .filter({$0 == true})
            .drive(onNext: { [weak self] isDisplayed in
                self?.searchResultsTableView.tableFooterView = self?.searchResultsLoadingFooterView
            }).disposed(by: self.disposeBag)
        
        self.searchResultsTableView.rx.didScroll.subscribe(onNext: { [weak self] _ in
            self?.searchBar.resignFirstResponder()
        }).disposed(by: self.disposeBag)
    }
    
    private func bindAddressSelectedEvent() {
        
        self.searchResultsTableView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                
                guard let cell = self?.searchResultsTableView.cellForRow(at: indexPath) as? PlaceTableViewCell else {
                    return
                }
                
                self?.navigateToSearchDeputyViewController(viewModel: cell.viewModel)
                TaggageManager.sendEvent(eventName: "address_selected")
                
            }).disposed(by: self.disposeBag)
    }
    
    // MARK: - Navigation
    
    func navigateToSearchDeputyViewController(viewModel: PlaceViewModel) {
        
        let searchDeputyViewController = R.storyboard.onboarding().instantiateViewController(withIdentifier: R.storyboard.onboarding.searchDeputyViewController.identifier) as! SearchDeputyViewController
        let searchDeputyViewModel = SearchDeputyViewModel(api: SingletonManager.sharedApiInstance, database: SingletonManager.sharedDatabaseInstance, userCoordinates:viewModel.place.coordinates)
        searchDeputyViewController.viewModel = searchDeputyViewModel
        
        self.navigationController?.pushViewController(searchDeputyViewController, animated: true)
        
    }
    
    // MARK: - Helpers
    
    func displayError(error:DAError) {
        
        let alertViewController = UIAlertController(title: R.string.localizable.error(), message: String(describing:error), preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .cancel, handler: nil))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
}
