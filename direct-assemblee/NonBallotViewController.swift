//
//  NonBallotViewController.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 10/08/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxSwift

class NonBallotViewController: BaseViewController, BindableType, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var infosTableView: UITableView!
    @IBOutlet weak var infosTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var readMoreButton: UIButton!
    
    var timelineEventViewModel:TimelineEventViewModel!
    
    typealias ViewModelType = NonBallotViewModel
    var viewModel:NonBallotViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.infosTableView.rowHeight = UITableViewAutomaticDimension
        self.infosTableView.estimatedRowHeight = 200
        self.infosTableView.separatorInset = .zero;
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        
        self.setupColors()
        self.bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        self.infosTableView.setNeedsLayout()
        self.infosTableView.layoutIfNeeded()
        self.infosTableViewHeightConstraint.constant = self.infosTableView.contentSize.height
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Style
    
    private func setupColors() {
        self.readMoreButton.tintColor = UIColor(hex: Constants.Color.blueLightColorCode)
    }
    

    //MARK: - Binding
    
    func bindViewModel() {
        
        self.viewModel.readMoreText.asObservable().bind(to: self.readMoreButton.rx.title(for: .normal)).disposed(by: self.disposeBag)
        
        self.viewModel.infosViewModels
            .asDriver()
            .drive(self.infosTableView.rx.items(cellIdentifier: R.reuseIdentifier.nonBallotInfoTableViewCellIdentifier.identifier, cellType: NonBallotInfoTableViewCell.self)) { (index, nonBallotInfoViewModel, nonBallotInfoCell) in
                nonBallotInfoCell.viewModel = nonBallotInfoViewModel
            }.disposed(by: self.disposeBag)

    }
    
    //MARK: - Actions
    
    @IBAction func onReadMoreTouch(_ sender: Any) {
        
        guard let url = self.viewModel.readMoreUrl, UIApplication.shared.canOpenURL(url) else {
            return
        }
        
        self.viewModel.didTapOnReadMore.onNext(())
        self.openWebUrl(url: url)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
