//
//  MoreMenuViewController.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 16/04/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxDataSources
import RxSwift

class MoreMenuViewController: BaseViewController, BindableType {

    @IBOutlet weak var tableView: UITableView!
    
    typealias ViewModelType = MoreMenuViewModel
    var viewModel: MoreMenuViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = R.string.localizable.more()
        
        self.tableView.tableFooterView = UIView()
        
        self.viewModel = MoreMenuViewModel(database: SingletonManager.sharedDatabaseInstance, api: SingletonManager.sharedApiInstance)
        self.bindViewModel()
        
    }
    
    //MARK: - Binding
    
    func bindViewModel() {
        self.bindMenuItems()
        self.bindItemSelection()
        self.bindExitDeputySelection()
        self.bindShareSelection()
        self.bindDonateSelection()
    }
    
    private func bindMenuItems() {
        self.viewModel.sections
            .asDriver()
            .drive(self.tableView.rx.items(dataSource:self.menuTableViewDataSource()))
            .disposed(by: disposeBag)
    }
    
    private func bindItemSelection() {
        
        self.tableView.rx.itemSelected
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.didSelectItem.onNext(indexPath)
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: self.disposeBag)
    }
    
    private func bindShareSelection() {
        self.viewModel.didShare.subscribe(onNext: { [weak self] shareInformation in
            self?.share(shareInformation)
        }).disposed(by: self.disposeBag)
    }
    
    private func bindDonateSelection() {
        self.viewModel.didDonate.subscribe(onNext: { url in
            UIApplication.shared.openURL(url)
        }).disposed(by: self.disposeBag)
    }
    
    private func bindExitDeputySelection() {
        
        self.viewModel.exitDeputyStatus.subscribe(onNext: { [weak self] status in
            
            switch status {
            case .askConfirmation:
                self?.displayExitDeputyConfirmation()
            case .confirmed:
                self?.view.addLoadingView(backgroundColor: UIColor(hex: Constants.Color.whiteColorCode), alpha: 0.7)
                self?.tabBarController?.tabBar.isHidden = true
            case .success:
                self?.view.removeLoadingView()
                self?.view.window?.rootViewController = R.storyboard.onboarding.onboardingNavigationController()
            case .error(let errorMessage):
                self?.view.removeLoadingView()
                self?.displayExitDeputyErrorMessage(errorMessage)
                self?.tabBarController?.tabBar.isHidden = false
            default:
                break
            }
            
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: - UITableView Data source
    
    func menuTableViewDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, MoreMenuItemViewModel>> {
        
        let configureCell:(TableViewSectionedDataSource<SectionModel<String, MoreMenuItemViewModel>>, UITableView, IndexPath, MoreMenuItemViewModel) -> UITableViewCell = { dataSource, tableView, indexPath, viewModel in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.moreMenuItemTableViewCell.identifier, for: indexPath) as! MoreMenuItemTableViewCell
            cell.viewModel = viewModel
            cell.selectionStyle = .blue
            
            return cell
        }

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, MoreMenuItemViewModel>>(configureCell: configureCell)
        
        return dataSource
    }
    
    // MARK: - Share
    
    private func share(_ shareInformation: ShareInformation) {
        let activityViewController = UIActivityViewController(activityItems: [shareInformation.text, shareInformation.url], applicationActivities: nil)
        activityViewController.view.tintColor = UIColor(hex: Constants.Color.blueColorCode)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Change deputy
    
    private func displayExitDeputyErrorMessage(_ errorMessage: String) {
        
        let errorAlertController = UIAlertController(title: R.string.localizable.error(), message: errorMessage, preferredStyle: .alert)
        errorAlertController.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .cancel, handler: nil))
        
        self.present(errorAlertController, animated: true, completion: nil)
    }
    
    private func displayExitDeputyConfirmation() {
        
        let deleteConfirmationAlertController = UIAlertController(title: R.string.localizable.change_deputy(), message: R.string.localizable.home_unfollow_deputy_confirmation(), preferredStyle: .actionSheet)
        deleteConfirmationAlertController.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: { [weak self] action in
            self?.viewModel.exitDeputyStatus.onNext(.denied)
        }))
        deleteConfirmationAlertController.addAction(UIAlertAction(title: R.string.localizable.confirm(), style: .destructive, handler: { [weak self] action in
            self?.viewModel.exitDeputyStatus.onNext(.confirmed)
        }))
        
        self.present(deleteConfirmationAlertController, animated: true, completion: nil)
    }
}
