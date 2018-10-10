//
//  BallotViewController.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 01/08/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxSwift

class BallotViewController: BaseViewController, BindableType {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var votesChartContainerView: UIView!
    @IBOutlet weak var isAdoptedImageView: UIImageView!
    @IBOutlet weak var isAdoptedLabel: UILabel!
    @IBOutlet weak var userDeputyVoteLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userDeputyVoteImageView: UIImageView!
    @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var readMoreButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var seeDetailsButton: UIButton!
    
    private var votesChartView: BarChartView!
    private var votesChartViewElements = [ChartElement]()
    
    typealias ViewModelType = BallotViewModel
    var viewModel:BallotViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.votesChartView = BarChartView()
        self.votesChartView.backgroundColor = UIColor.clear
        self.votesChartContainerView.add(constraintedSubview: self.votesChartView)
        self.votesChartView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onChartViewTouched)))
        
        self.setupColors()
        self.bindViewModel()
    }
    
    // MARK: - Style
    
    private func setupColors() {
        self.descriptionLabel.textColor = UIColor(hex: Constants.Color.blackColorCode)
        self.isAdoptedLabel.textColor = UIColor(hex: self.viewModel.isAdoptedStatusColorCode.value)
        self.userDeputyVoteLabel.textColor = UIColor(hex: self.viewModel.userDeputyVoteColorCode.value)
        self.readMoreButton.tintColor = UIColor(hex: Constants.Color.blueLightColorCode)
    }
    
    // MARK: - Binding
    
    func bindViewModel() {
        
        self.viewModel.isAdoptedText.asDriver().drive(self.isAdoptedLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.userDeputyVoteResultText.asDriver().drive(self.userDeputyVoteLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.descriptionText.asDriver().drive(self.descriptionLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.dateText.asDriver().drive(self.dateLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.readMoreText.asDriver().drive(self.readMoreButton.rx.title(for: .normal)).disposed(by: self.disposeBag)
        self.viewModel.seeDetailsText.asDriver().drive(self.seeDetailsButton.rx.title(for: .normal)).disposed(by: self.disposeBag)
        self.readMoreButtonHeightConstraint.constant = self.viewModel.readMoreUrl != nil ? 30 : 0
        
        self.bindVotesData()
        self.bindVotesResult()
        self.bindDisplayVotesDetails()
    }
    
    private func bindVotesResult() {
        
        self.isAdoptedImageView.image = self.isAdoptedImageView.image?.withRenderingMode(.alwaysTemplate)
        self.isAdoptedImageView.tintColor = UIColor.init(hex: self.viewModel.isAdoptedStatusColorCode.value)
        
        self.viewModel.userDeputyVoteImageName.asDriver().drive(onNext: { [weak self] imageName in
            self?.userDeputyVoteImageView.image = UIImage(named: imageName)
            self?.userDeputyVoteImageView.image = self?.userDeputyVoteImageView.image?.withRenderingMode(.alwaysTemplate)
            self?.userDeputyVoteImageView.tintColor = UIColor.init(hex: self?.viewModel.userDeputyVoteColorCode.value ?? Constants.Color.greenColorCode)
        }).disposed(by: self.disposeBag)
    }
    
    private func bindVotesData() {
        
        self.viewModel.votesData.asDriver().drive(onNext: { [weak self] tuples in
            
            for tuple in tuples {
                let chartElement = ChartElement(value: tuple.value, color: UIColor(hex:tuple.colorCode), label: tuple.label)
                self?.votesChartViewElements.append(chartElement)
            }
            
            self?.votesChartView.elements = self?.votesChartViewElements ?? []
            self?.votesChartView.setNeedsDisplay()
            
        }).disposed(by: self.disposeBag)
    }
    
    private func bindDisplayVotesDetails() {
        
        self.viewModel.displayVotesDetailStatus
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] status in
                
                switch status {
                case .readyToDisplay(let viewModel):
                    let vc = R.storyboard.deputy().instantiateViewController(withIdentifier: R.storyboard.deputy.ballotDeputiesVotesViewController.identifier) as! BallotDeputiesVotesViewController
                    vc.viewModel = viewModel
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                default:
                    break
                }
                
            }).disposed(by: self.disposeBag)
    }
    
    //MARK: - Actions
    
    @IBAction func OnReadMoreTOuch(_ sender: Any) {
        
        guard let url = self.viewModel.readMoreUrl, UIApplication.shared.canOpenURL(url) else {
            return
        }
        
        self.viewModel.didTapOnReadMore.onNext(())
        self.openWebUrl(url: url)
    }
    
    @IBAction func onSeeDetailsTouched(_ sender: Any) {
        self.viewModel.displayVotesDetailStatus.onNext(.selected)
    }
    
    @objc func onChartViewTouched(_ sender: Any) {
        self.viewModel.displayVotesDetailStatus.onNext(.selected)
    }
}


