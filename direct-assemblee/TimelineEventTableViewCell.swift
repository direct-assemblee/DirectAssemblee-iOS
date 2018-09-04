//
//  TimelineEventTableViewCell.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 07/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxSwift

class TimelineEventTableViewCell: BaseTableViewCell, BindableType {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var eventContainerView: UIView!
    @IBOutlet weak var themeImageViewContainer: UIView!
    @IBOutlet weak var themeImageView: UIImageView!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var isAdoptedImageView: UIImageView!
    @IBOutlet weak var isAdoptedStatusLabel: UILabel!
    @IBOutlet weak var isAdoptedStatusIndicatorView: UIView!
    @IBOutlet weak var userDeputyAdoptedStatusLabel: UILabel!
    @IBOutlet weak var userDeputyIconImageView: UIImageView!
    @IBOutlet weak var resultsViewHeightConstraint: NSLayoutConstraint!
    
    typealias ViewModelType = TimelineEventViewModel
    var viewModel:TimelineEventViewModel! {
        didSet {
            self.bindViewModel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupColors()
        self.themeImageViewContainer.layer.cornerRadius = self.themeImageViewContainer.frame.size.width / 2
        
        //Remove new cell margins on iOS 11
        self.preservesSuperviewLayoutMargins = false
    }
    
    //MARK: - Style
    
    private func setupColors() {
        self.dateLabel.textColor = UIColor(hex: Constants.Color.blackColorCode)
        self.titleLabel.textColor = UIColor(hex: Constants.Color.blackColorCode)
        self.descriptionLabel.textColor = UIColor(hex: Constants.Color.blackColorCode)
        self.themeLabel.textColor = UIColor(hex: Constants.Color.blueColorCode)
        self.selectedBackgroundView = UIView(frame: self.frame)
        self.selectedBackgroundView?.backgroundColor = UIColor(hex: Constants.Color.blueLightColorCode)
    }
    
    //MARK: - Binding
    
    func bindViewModel() {

        self.viewModel.dateText.asObservable().bind(to: self.dateLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.descriptionText.asObservable().bind(to: self.descriptionLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.titleText.asObservable().bind(to: self.titleLabel.rx.text).disposed(by: self.disposeBag)

        self.bindTheme()
        self.bindVoteInfos()
        
    }

    private func bindVoteInfos() {

        self.isAdoptedImageView.image = self.isAdoptedImageView.image?.withRenderingMode(.alwaysTemplate)
        self.isAdoptedImageView.tintColor = UIColor.init(hex: self.viewModel.isAdoptedStatusColorCode)
        self.isAdoptedStatusLabel.textColor = UIColor(hex: self.viewModel.isAdoptedStatusColorCode)
        self.viewModel.isAdoptedText.asObservable().bind(to: self.isAdoptedStatusLabel.rx.text).disposed(by: self.disposeBag)
        
        self.viewModel.userDeputyVoteResultText.asObservable().bind(to: self.userDeputyAdoptedStatusLabel.rx.text).disposed(by: self.disposeBag)
        self.userDeputyAdoptedStatusLabel.textColor =  UIColor.init(hex: self.viewModel.userDeputyVoteColorCode)
        
        if let userDeputyVoteResultImageName = viewModel.userDeputyVoteResultImageName {
            self.userDeputyIconImageView.image = UIImage(named: userDeputyVoteResultImageName)
            self.userDeputyIconImageView.image = self.userDeputyIconImageView.image?.withRenderingMode(.alwaysTemplate)
            self.userDeputyIconImageView.tintColor = UIColor.init(hex: self.viewModel.userDeputyVoteColorCode)
        }
        
        self.isAdoptedStatusIndicatorView.backgroundColor = UIColor(hex: Constants.Color.blueColorCode)
        self.resultsViewHeightConstraint.constant = self.viewModel.isVoteEvent ? 25 : 0
        
    }
    
    
    private func bindTheme() {
        
        self.viewModel.themeImageName.asObservable().subscribe(onNext: { [weak self] themeImageName in
            self?.themeImageView.image = UIImage(named: themeImageName)
            self?.themeImageView.image = self?.themeImageView.image?.withRenderingMode(.alwaysTemplate)
            self?.themeImageView.tintColor = UIColor(hex: Constants.Color.whiteColorCode)
        }).disposed(by: self.disposeBag)
        
        self.viewModel.themeText.asObservable().bind(to: self.themeLabel.rx.text).disposed(by: self.disposeBag)
        self.themeImageViewContainer.backgroundColor = UIColor(hex: Constants.Color.blueColorCode)
    }


}
