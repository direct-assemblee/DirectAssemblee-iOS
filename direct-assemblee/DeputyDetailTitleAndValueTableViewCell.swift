//
//  DeputyDetailTitleAndValueTableViewCell.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 14/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxSwift
import RxCocoa
 
class DeputyDetailTitleAndValueTableViewCell: DeputyDetailBaseTableViewCell, BindableType {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    typealias ViewModelType = DeputyDetail
    override var viewModel:DeputyDetail! {
        didSet {
            self.bindViewModel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupColors()
    }
    
    func setupColors() {
        self.valueLabel.textColor = UIColor(hex: Constants.Color.blackColorCode)
        self.titleLabel.textColor = UIColor(hex: Constants.Color.blueColorCode)
    }
    
    func bindViewModel() {
        
        guard let viewModel = self.viewModel as? DeputyDetailTitleAndValueViewModel else {
            return
        }
        
        viewModel.titleText.asDriver().drive(self.titleLabel.rx.text).disposed(by: self.disposeBag)
        viewModel.valueText.asDriver().drive(self.valueLabel.rx.text).disposed(by: self.disposeBag)
    }
    
}
