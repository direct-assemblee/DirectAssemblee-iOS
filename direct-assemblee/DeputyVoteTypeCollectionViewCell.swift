//
//  DeputyVoteCell.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 29/05/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import UIKit

class DeputyVoteTypeCollectionViewCell: BaseCollectionViewCell, BindableType {
    
    @IBOutlet weak var voteTypeLabel: UILabel!
    
    typealias ViewModel = DeputyVoteTypeViewModel
    var viewModel: DeputyVoteTypeViewModel! {
        didSet {
            self.bindViewModel()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.setupColors()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupColors()
    }
    
    // MARK: - Binding
    
    func bindViewModel() {
        self.viewModel.voteTypeLabel.asDriver().drive(self.voteTypeLabel.rx.text).disposed(by: self.disposeBag)
    }
    
    // MARK: - Setup
    
    private func setupColors() {
        self.backgroundColor = isSelected ? UIColor(hex: Constants.Color.blueColorCode) : UIColor(hex: Constants.Color.whiteColorCode)
        self.voteTypeLabel.textColor = isSelected ? UIColor(hex: Constants.Color.whiteColorCode) : UIColor(hex: Constants.Color.blueColorCode)
    }
}
