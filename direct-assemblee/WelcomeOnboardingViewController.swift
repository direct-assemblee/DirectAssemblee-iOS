//
//  DiscoverDeputyViewController.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 03/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit

class WelcomeOnboardingViewController: BaseViewController, BindableType {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var geolocationButton: UIButton!
    @IBOutlet weak var listButton: RoundedButton!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var addressDisclaimer: UILabel!
    
    typealias ViewModelType = WelcomeOnboardingViewModel
    var viewModel:WelcomeOnboardingViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = WelcomeOnboardingViewModel()
        
        self.setupColors()
        self.bindViewModel()
        
    }
    
    // MARK: - Style
    
    private func setupColors() {
        self.welcomeLabel.textColor = UIColor(hex: Constants.Color.blackColorCode)
    }
    
    // MARK: - Setup
    
    func bindViewModel() {
        self.viewModel.welcomeText.asDriver().drive(self.welcomeLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.useGeolocationText.asDriver().drive(self.geolocationButton.rx.title(for: .normal)).disposed(by: self.disposeBag)
        self.viewModel.useAllDeputiesList.asDriver().drive(self.listButton.rx.title(for: .normal)).disposed(by: self.disposeBag)
        self.viewModel.enterAddressText.asDriver().drive(self.addressButton.rx.title(for: .normal)).disposed(by: self.disposeBag)
        self.viewModel.addressDisclaimerText.asDriver().drive(self.addressDisclaimer.rx.text).disposed(by: self.disposeBag)
        
    }
    
    @IBAction func onGeolocationTouched(_ sender: Any) {
        TaggageManager.sendEvent(eventName: "search_deputy_geolocation")
    }
    
    @IBAction func onAddressTouched(_ sender: Any) {
        
        TaggageManager.sendEvent(eventName: "search_deputy_address")
        let vc = R.storyboard.onboarding().instantiateViewController(withIdentifier: R.storyboard.onboarding.searchDeputyByAddressViewController.identifier) as! SearchDeputyByAddressViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onAllDeputiesTouched(_ sender: Any) {
        let vc = SearchDeputyInListViewController.instanciateForFollowMode()
        self.navigationController?.pushViewController(vc, animated: true)
        TaggageManager.sendEvent(eventName: "search_deputy_in_list")
    }
    
}
