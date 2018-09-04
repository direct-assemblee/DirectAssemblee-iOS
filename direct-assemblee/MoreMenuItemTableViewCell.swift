//
//  MoreMenuItemTableViewCell.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 16/04/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import UIKit
import RxSwift

class MoreMenuItemTableViewCell: BaseTableViewCell, BindableType {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    
    typealias ViewModelType = MoreMenuItemViewModel
    var viewModel: MoreMenuItemViewModel! {
        didSet {
            self.bindViewModel()
        }
    }
    
    func bindViewModel() {

        self.itemImageView.image = UIImage(named: viewModel.itemImageName)
        self.itemImageView.tintColor = UIColor(hex: Constants.Color.blueColorCode)
        self.itemNameLabel.text = viewModel.itemText
        
    }
}
