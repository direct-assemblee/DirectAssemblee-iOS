//
//  DeputyHeaderViewController.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 06/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxSwift
import RxCocoa

class DeputyHeaderCardViewController: BaseViewController, BindableType {
    
    @IBOutlet weak var bottomSeparatorView: UIView!
    @IBOutlet weak var completeNameLabel: UILabel!
    @IBOutlet weak var parliamentGroupLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var activityRateLabel: UILabel!
    @IBOutlet weak var activityRateTitleLabel: UILabel!
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var informationButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var reducedPhotoButton: UIButton!
    @IBOutlet weak var reducedInformationButton: UIButton!
    @IBOutlet weak var reducedHeaderCompleteNameLabel: UILabel!
    @IBOutlet weak var reducedHeaderParliamentGroupLabel: UILabel!
    
    private var previousHeight:CGFloat = Constants.Sizes.deputyHeaderCardMaxHeight
    
    private var isReducing:Bool {
        return self.view.bounds.size.height > Constants.Sizes.deputyHeaderCardMinHeight
            && self.view.bounds.size.height < Constants.Sizes.deputyHeaderCardMaxHeight
            && self.view.bounds.size.height < self.previousHeight
    }
    
    private var isExpanding:Bool {
        return self.view.bounds.size.height > Constants.Sizes.deputyHeaderCardMinHeight
            && self.view.bounds.size.height < Constants.Sizes.deputyHeaderCardMaxHeight
            && self.view.bounds.size.height > self.previousHeight
    }
    
    typealias ViewModelType = DeputyHeaderCardViewModel
    var viewModel:DeputyHeaderCardViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
        
        self.setupColors()
        self.setupPhotos()
        self.setupButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.configureAlphaForReducedCard()
        self.configureAlphaForExtendedCard()
        
        self.previousHeight = self.view.bounds.size.height
        
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Style
    
    func setupColors() {
        self.backgroundView.backgroundColor = UIColor(hex: Constants.Color.blueColorCode)
        self.bottomSeparatorView.backgroundColor = UIColor(hex: Constants.Color.whiteColorCode)
        self.completeNameLabel.textColor = UIColor(hex: Constants.Color.whiteColorCode)
        self.parliamentGroupLabel.textColor = UIColor(hex: Constants.Color.whiteColorCode)
        self.districtLabel.textColor = UIColor(hex: Constants.Color.whiteColorCode)
        self.activityRateLabel.textColor = UIColor(hex: Constants.Color.whiteColorCode)
        self.activityRateTitleLabel.textColor = UIColor(hex: Constants.Color.whiteColorCode)
        self.reducedHeaderCompleteNameLabel.textColor = UIColor(hex: Constants.Color.whiteColorCode)
        self.reducedHeaderParliamentGroupLabel.textColor = UIColor(hex: Constants.Color.whiteColorCode)
    }
    
    private func setupButtons() {
        
        self.setupButton(self.closeButton)
        
        self.informationButton.layer.cornerRadius = self.informationButton.frame.width/2
        self.setupButton(self.informationButton, withBackgroundColor: UIColor(hex: Constants.Color.blueColorCode))
        
        self.reducedInformationButton.layer.cornerRadius = self.reducedInformationButton.frame.width/2
        self.setupButton(self.reducedInformationButton, withBackgroundColor: UIColor(hex: Constants.Color.blueColorCode))
    }
    
    private func setupButton(_ button: UIButton, withBackgroundColor backgroundColor:UIColor = UIColor.clear) {
        button.setImage(button.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(button.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        button.imageView?.tintColor = UIColor(hex: Constants.Color.whiteColorCode)
        button.tintColor =  UIColor(hex: Constants.Color.whiteColorCode)
        button.backgroundColor = backgroundColor
    }
    
    private func setupPhotos() {
        
        self.photoButton.layer.cornerRadius = self.photoButton.frame.width/2
        self.photoButton.clipsToBounds = true
        self.photoButton.layer.borderWidth = 2
        self.photoButton.layer.borderColor = UIColor(hex: Constants.Color.whiteColorCode).cgColor
        
        self.reducedPhotoButton.layer.cornerRadius = self.reducedPhotoButton.frame.width/2
        self.reducedPhotoButton.clipsToBounds = true
        self.reducedPhotoButton.layer.borderWidth = 2
        self.reducedPhotoButton.layer.borderColor = UIColor(hex: Constants.Color.whiteColorCode).cgColor
    }
    
    // MARK: - Binding
    
    func bindViewModel() {
        
        self.bindDeputyInformations()
        self.bindNeededProfileActions()
        self.bindHiddenItems()
        self.bindPhoto()
        self.bindDisplayProfileEvent()
    }
    
    private func bindDeputyInformations() {
        
        self.viewModel.completeNameText.asDriver().drive(self.completeNameLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.completeNameText.asDriver().drive(self.reducedHeaderCompleteNameLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.parliamentGroupText.asDriver().drive(self.parliamentGroupLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.parliamentGroupText.asDriver().drive(self.reducedHeaderParliamentGroupLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.districtText.asDriver().drive(self.districtLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.activityRateText.asDriver().drive(self.activityRateLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.activityRateTitleText.asDriver().drive(self.activityRateTitleLabel.rx.text).disposed(by: self.disposeBag)
    }
    

    
    private func bindNeededProfileActions() {
        self.viewModel.isProfileAvailable.asDriver().drive(self.photoButton.rx.isUserInteractionEnabled).disposed(by: self.disposeBag)
        self.viewModel.isProfileAvailable.asDriver().drive(self.informationButton.rx.isUserInteractionEnabled).disposed(by: self.disposeBag)
        self.viewModel.isProfileAvailable.asDriver().drive(self.reducedPhotoButton.rx.isUserInteractionEnabled).disposed(by: self.disposeBag)
        self.viewModel.isProfileAvailable.asDriver().drive(self.reducedInformationButton.rx.isUserInteractionEnabled).disposed(by: self.disposeBag)
    }
    
    private func bindHiddenItems() {
        self.viewModel.isReducedPhotoViewHidden.asDriver().drive(self.reducedPhotoButton.rx.isHidden).disposed(by: self.disposeBag)
        self.viewModel.isReducedInformationButtonViewHidden.asDriver().drive(self.reducedInformationButton.rx.isHidden).disposed(by: self.disposeBag)
        self.viewModel.isInformationButtonHidden.asDriver().drive(self.informationButton.rx.isHidden).disposed(by: self.disposeBag)
        self.viewModel.isBackButtonHidden.asDriver().drive(self.backButton.rx.isHidden).disposed(by: self.disposeBag)
        self.viewModel.isCloseButtonHidden.asDriver().drive(self.closeButton.rx.isHidden).disposed(by: self.disposeBag)
        self.viewModel.isActivityHidden.asDriver().drive(self.activityRateLabel.rx.isHidden).disposed(by: self.disposeBag)
        self.viewModel.isActivityHidden.asDriver().drive(self.activityRateTitleLabel.rx.isHidden).disposed(by: self.disposeBag)
    }
    
    private func bindPhoto() {
        
        self.viewModel.photoData.asDriver()
            .drive(onNext: { [weak self] photoData in
                self?.photoButton.setImage(UIImage(data: photoData), for: .normal)
                self?.photoButton.imageView?.contentMode = .scaleAspectFill
                self?.reducedPhotoButton.setImage(UIImage(data: photoData), for: .normal)
                self?.reducedPhotoButton.imageView?.contentMode = .scaleAspectFill
            }).disposed(by: self.disposeBag)
    }

    private func bindDisplayProfileEvent() {
        
        self.viewModel.deputyProfileViewModelToDisplay.subscribe(onNext: { [weak self] viewModel in
            
            let deputyDetailsViewController = R.storyboard.deputy().instantiateViewController(withIdentifier: R.storyboard.deputy.deputyDetailsViewController.identifier) as! DeputyDetailsViewController
            deputyDetailsViewController.viewModel = viewModel.contentViewModel as! DeputyDetailsViewModel
            
            let deputyFloatingHeaderViewController = DeputyFloatingHeaderViewController.instanciateWithContentViewController(deputyDetailsViewController)
            deputyFloatingHeaderViewController.viewModel = viewModel
            
            self?.navigationController?.pushViewController(deputyFloatingHeaderViewController, animated: true)
            
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: - Alpha management
    
    private func configureAlphaForReducedCard() {
        let currentHeightPercentage = self.currentHeightPercentage(betweenMaxHeight: Constants.Sizes.deputyHeaderCardMinHeight + 20, andMinHeight: Constants.Sizes.deputyHeaderCardMinHeight)
        self.reducedPhotoButton.alpha = 1 - currentHeightPercentage
        self.reducedInformationButton.alpha = 1 - currentHeightPercentage
        self.reducedHeaderCompleteNameLabel.alpha = 1 - currentHeightPercentage
        self.reducedHeaderParliamentGroupLabel.alpha = 1 - currentHeightPercentage
    }
    
    private func configureAlphaForExtendedCard() {
        let currentHeightPercentage = self.currentHeightPercentage(betweenMaxHeight: Constants.Sizes.deputyHeaderCardMaxHeight, andMinHeight: Constants.Sizes.deputyHeaderCardMinHeight)
        self.informationButton.alpha = currentHeightPercentage
        self.completeNameLabel.alpha = currentHeightPercentage
        self.districtLabel.alpha = currentHeightPercentage
        self.parliamentGroupLabel.alpha = currentHeightPercentage
        self.activityRateLabel.alpha = currentHeightPercentage
        self.activityRateTitleLabel.alpha = currentHeightPercentage
    }
    
    private func currentHeightPercentage(betweenMaxHeight maxHeight:CGFloat, andMinHeight minHeight:CGFloat) -> CGFloat {
        
        let heightRange = maxHeight - minHeight
        var heightVariation:CGFloat = heightRange
        
        if self.isReducing {
            heightVariation = (self.view.bounds.height < minHeight ? minHeight : self.view.bounds.height) - minHeight
        } else if self.isExpanding {
            heightVariation = (self.view.bounds.height > maxHeight ? maxHeight : self.view.bounds.height) - minHeight
        } else if self.view.bounds.height - minHeight == 0 {
            heightVariation = 0
        }
        
        return heightVariation/CGFloat(heightRange)
    }

    
    // MARK: - Actions
    
    @IBAction func onDisplayProfileTouched(_ sender: Any) {
        self.viewModel.didTapOnDisplayDeputyProfile.onNext(())
    }
    
    @IBAction func handleTapGesture(_ sender: Any) {
        
        guard self.view.frame.size.height == Constants.Sizes.deputyHeaderCardMinHeight else {
            return
        }
        
        self.viewModel.didTapOnReducedHeader.onNext(())
    }
}
