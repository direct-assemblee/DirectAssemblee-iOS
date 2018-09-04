//
//  DeputyDetailsViewController.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 14/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import MessageUI

class DeputyDetailsViewController: BaseViewController, BindableType, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var detailsTableView: UITableView!
    
    typealias ViewModelType = DeputyDetailsViewModel
    var viewModel:DeputyDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailsTableView.rowHeight = UITableViewAutomaticDimension
        self.detailsTableView.estimatedRowHeight = 48
        self.detailsTableView.delegate = self
        self.detailsTableView.backgroundColor = UIColor.clear
        self.detailsTableView.contentInset = UIEdgeInsetsMake(Constants.Sizes.deputyHeaderCardMaxHeight, 0, 0, 0)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        
        self.bindViewModel()
        
    }
    
    // MARK:- Binding
    
    func bindViewModel() {
        
        self.viewModel.infosSections
            .asDriver()
            .drive(self.detailsTableView.rx.items(dataSource:self.detailsTableViewDataSource()))
            .disposed(by: disposeBag)
        
        self.bindListSelectionEvent()
        self.bindSelectedPhoneEvent()
        self.bindSelectedEmailEvent()
        self.bindSelectedDeclarationEvent()
        self.bindScrollEvents()
        
    }
    
    private func bindListSelectionEvent() {
        
        self.detailsTableView.rx.itemSelected
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.didSelectInfo.onNext(indexPath)
                self?.detailsTableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: self.disposeBag)
    }
    
    private func bindSelectedDeclarationEvent() {
        
        self.viewModel.selectedDeclarationViewerViewModel
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] viewModel in
                
                let deputyDeclarationViewerViewController = R.storyboard.deputy.deputyDeclarationViewerViewController()!
                deputyDeclarationViewerViewController.viewModel = viewModel
                self?.navigationController?.pushViewController(deputyDeclarationViewerViewController, animated: true)
                
            }).disposed(by: self.disposeBag)
    }
    
    private func bindSelectedPhoneEvent() {
    
        self.viewModel.selectedPhoneNumberUrl.subscribe(onNext: { phoneNumberUrl in
            
            if UIApplication.shared.canOpenURL(phoneNumberUrl) {
                UIApplication.shared.openURL(phoneNumberUrl)
            }

        }).disposed(by: self.disposeBag)
    }
    
    private func bindSelectedEmailEvent() {
    
        self.viewModel.selectedEmail.subscribe(onNext: { [weak self] email in
            
            guard MFMailComposeViewController.canSendMail() else {
                self?.displayNoMailComposerAlert()
                return
            }
            
            let mail = MFMailComposeViewController()
            mail.setToRecipients([email])
            mail.mailComposeDelegate = self
            self?.present(mail, animated: true)
            
        }).disposed(by: self.disposeBag)
    
    }
    
    
    private func bindScrollEvents() {
        
        self.detailsTableView.rx.didScroll.subscribe(onNext: { [weak self] _ in
            self?.viewModel.listScrollOffset.onNext(self?.detailsTableView.contentOffset.y ?? 0)
        }).disposed(by: self.disposeBag)
        
        self.viewModel.didUserWantToScrollToTop.subscribe(onNext: { [weak self] _ in
            self?.detailsTableView.setContentOffset(CGPoint(x: 0, y: -Constants.Sizes.deputyHeaderCardMaxHeight), animated: true)
        }).disposed(by: self.disposeBag)
        
    }
    
    // MARK: - UITableView Data source
    
    func detailsTableViewDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, DeputyDetail>> {
        
        let configureCell:(TableViewSectionedDataSource<SectionModel<String, DeputyDetail>>, UITableView, IndexPath, DeputyDetail) -> UITableViewCell = { dataSource, tableView, indexPath, deputyDetail in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: deputyDetail.cellIdentifier, for: indexPath) as! DeputyDetailBaseTableViewCell
            cell.viewModel = deputyDetail
            cell.accessoryType =  deputyDetail.isSelectable ? .disclosureIndicator : .none
            cell.selectionStyle =  deputyDetail.isSelectable ? .blue : .none
            cell.isUserInteractionEnabled =  deputyDetail.isSelectable
            
            return cell
        }
        
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, DeputyDetail>>(configureCell: configureCell)
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }
        

        return dataSource
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = R.nib.deputyDetailSectionView.firstView(owner: nil)
        view?.titleLabel.text = self.viewModel.infosSections.value[section].model
        view?.titleLabel.textColor = UIColor(hex: Constants.Color.redColorCode)
        view?.backgroundColor = UIColor.clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        view.backgroundColor = UIColor.white
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }

    //MARK: - Private helpers
    
    private func displayNoMailComposerAlert() {
        
        let alertController = UIAlertController(title: R.string.localizable.error(), message: R.string.localizable.error_no_mail_available(), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
}
