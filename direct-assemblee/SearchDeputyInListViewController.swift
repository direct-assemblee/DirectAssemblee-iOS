//
//  SearchDeputyInListViewController.swift
//  direct-assemblee
//
//  Created by Julien on 08/03/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxSwift

class SearchDeputyInListViewController: BaseViewController, BindableType {
    
    @IBOutlet weak var reloadButton: RoundedButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var deputiesListViewContainer: UIView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var deputiesListViewController:DeputiesListViewController!
    
    typealias ViewModelType = SearchDeputyInListViewModel
    var viewModel:SearchDeputyInListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
    }
    
    static func instanciateForFollowMode() -> SearchDeputyInListViewController {
        return SearchDeputyInListViewController.instanciate(for: .follow)
    }
    
    static func instanciateForConsultationMode() -> SearchDeputyInListViewController {
        return SearchDeputyInListViewController.instanciate(for: .consult)
    }
    
    static func instanciate(for deputyMode: DeputyMode) -> SearchDeputyInListViewController {
        let viewController = R.storyboard.common.searchDeputyInListViewController()!
        viewController.viewModel = SearchDeputyInListViewModel(api: SingletonManager.sharedApiInstance, database: SingletonManager.sharedDatabaseInstance, deputyMode: deputyMode)
        
        return viewController
    }
    
    // MARK: - Binding
    
    func bindViewModel() {
        
        self.bindSearchBar()
        self.bindDeputiesList()
        self.bindLoadingView()
        self.bindErrorView()
        self.bindConfirmDeputy()
    }
    
    private func bindSearchBar() {
        
        self.searchBar.rx.text.orEmpty
            .skip(1)
            .distinctUntilChanged()
            .debounce(0.5, scheduler: MainScheduler.instance)
            .asObservable().bind(to: self.viewModel.searchText).disposed(by: self.disposeBag)
        
        self.viewModel.isSearchEnabled.asObservable().bind(to: self.searchBar.rx.isUserInteractionEnabled).disposed(by: self.disposeBag)
        self.searchBar.placeholder = self.viewModel.enterNamePlaceholderText
    }
    
    private func bindDeputiesList() {
        
        self.viewModel.deputiesListViewModel.asObservable()
            .filter{ $0 != nil }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] viewModel in
                self?.setupDeputiesListViewController(viewModel: viewModel!)
            }).disposed(by: self.disposeBag)
    }
    
    private func bindLoadingView() {
        
        self.viewModel.isLoadingViewHidden.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isHidden in
            if isHidden {
                self?.deputiesListViewContainer.removeLoadingView()
            } else {
                self?.deputiesListViewContainer.addLoadingView()
            }
        }).disposed(by: self.disposeBag)
        
        self.viewModel.isLoadingViewHidden.asObservable()
            .map{!$0}
            .bind(to: self.deputiesListViewContainer.rx.isHidden).disposed(by: self.disposeBag)
    }
    
    private func bindErrorView() {
        
        self.viewModel.isErrorViewHidden.asObservable().bind(to: self.errorView.rx.isHidden).disposed(by: self.disposeBag)
        self.viewModel.isErrorViewHidden.asObservable()
            .map{!$0}
            .bind(to: self.deputiesListViewContainer.rx.isHidden).disposed(by: self.disposeBag)
        self.viewModel.errorPlaceholderText.asObservable().bind(to: self.errorLabel.rx.text).disposed(by: self.disposeBag)
        self.reloadButton.setTitle(self.viewModel.reloadText, for: .normal)
    }
    
    private func bindConfirmDeputy() {
        
        self.viewModel.didSelectDeputy
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] status in
                
                switch status {
                case .askFollowConfirm(let viewModel):
                    self?.displayConfirmFollowDeputyAlert(viewModel: viewModel)
                case .followStarts:
                    self?.view.window?.rootViewController = TabBarViewController()
                case .consultationStarts(let viewModel):
                    let viewController = DeputyMainViewController.instanciate(with: viewModel)
                    let navigationController = UINavigationController(rootViewController: viewController)
                    navigationController.isNavigationBarHidden = true
                    self?.present(navigationController, animated: true, completion: nil)
                default:
                    break
                }
                
            }).disposed(by: self.disposeBag)

    }
    
    // MARK: - Actions
    
    @IBAction func onReloadTouched(_ sender: Any) {
        self.viewModel.loadDeputies()
    }
    
    
    // MARK: - Helpers
    
    private func setupDeputiesListViewController(viewModel: DeputiesListViewModel) {
        
        self.deputiesListViewController = DeputiesListViewController.instanciate()
        self.deputiesListViewController.viewModel = viewModel
        self.add(childViewController: self.deputiesListViewController, inView: self.deputiesListViewContainer)
        
        self.deputiesListViewController.didScroll.subscribe(onNext: { [weak self] _ in
            self?.searchBar.resignFirstResponder()
        }).disposed(by: self.disposeBag)
        
        self.deputiesListViewController.didSelectViewModel.subscribe(onNext: { [weak self] viewModel in
            self?.viewModel.didSelectDeputy.onNext(SelectDeputyStatus.selected(viewModel))
        }).disposed(by: self.disposeBag)
        
    }
    
    private func displayConfirmFollowDeputyAlert(viewModel: DeputySummaryViewModel) {
        
        let alertController = UIAlertController(title: "Direct Assemblée", message: R.string.localizable.confirm_follow_deputy(viewModel.completeNameText.value), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: R.string.localizable.ok().uppercased(), style: .default, handler: { [weak self] action in
            self?.viewModel.didSelectDeputy.onNext(SelectDeputyStatus.followConfirmed(viewModel))
        }))
        alertController.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler:nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
