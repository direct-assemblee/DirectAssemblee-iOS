//
//  PlaceTableViewCell.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 10/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxSwift
import RxCocoa

class PlaceTableViewCell: BaseTableViewCell, BindableType {

    @IBOutlet weak var addressLabel: UILabel!
    
    typealias ViewModelType = PlaceViewModel
    var viewModel:PlaceViewModel! {
        didSet {
           self.bindViewModel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupColors()
    }
    
    func setupColors() {
        self.addressLabel.textColor = UIColor(hex: Constants.Color.blackColorCode)
    }
    
    func bindViewModel() {
        self.viewModel.addressText.asObservable().bind(to: self.addressLabel.rx.text).disposed(by: self.disposeBag)
    }

}
