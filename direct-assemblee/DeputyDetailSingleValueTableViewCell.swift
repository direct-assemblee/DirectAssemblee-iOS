//
//  DeputyDetailSingleValueTableViewCell.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 04/07/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift
import RxCocoa

class DeputyDetailSingleValueTableViewCell: DeputyDetailBaseTableViewCell, BindableType  {
    
    @IBOutlet weak var valueLabelLeadingConstraint: NSLayoutConstraint!
    
    typealias ViewModelType = DeputyDetail
    override var viewModel: DeputyDetail! {
        didSet {
            self.bindViewModel()
        }
    }
    
    func bindViewModel() {
        
        guard let viewModel = self.viewModel as? DeputyDetailSingleValueViewModel else {
            return
        }
        
        viewModel.valueText.asDriver().drive(self.valueLabel.rx.text).disposed(by: self.disposeBag)
        
        self.setupStyle()
    }
    
    private func setupStyle() {
        
        self.valueLabelLeadingConstraint.constant = CGFloat(self.viewModel.level * -10)
        
        switch self.viewModel.level {
        case 0:
            self.valueLabel.textColor = UIColor(hex: Constants.Color.blueColorCode)
            self.valueLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        case 1:
            self.valueLabel.textColor = UIColor(hex: Constants.Color.blackColorCode)
            self.valueLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        case 2:
            self.valueLabel.textColor = UIColor(hex: Constants.Color.blackColorCode)
            self.valueLabel.font = UIFont.systemFont(ofSize: 13)
        default:
            break
        }
    }
}
