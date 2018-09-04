//
//  NonBallotInfoTableViewCell.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 07/10/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit

class NonBallotInfoTableViewCell: BaseTableViewCell, BindableType {

    @IBOutlet weak var infoLabel: UILabel!
    
    typealias ViewModel = NonBallotInfoViewModel
    var viewModel:NonBallotInfoViewModel! {
        didSet {
            self.bindViewModel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupColors()
    }
    
    func setupColors() {
        self.infoLabel.textColor = UIColor(hex: Constants.Color.blackColorCode)
    }

    func bindViewModel() {
        
        self.viewModel.textValue.asObservable().bind(to: self.infoLabel.rx.text).disposed(by: self.disposeBag)
        self.bindStyle()
    }
    
    private func bindStyle() {
        
        self.viewModel.textSize.asObservable().subscribe(onNext: { [weak self] size in
            self?.infoLabel?.font = UIFont.systemFont(ofSize: CGFloat(size))
        }).disposed(by: self.disposeBag)
        
        self.viewModel.isCentered.asObservable().subscribe(onNext: { isCentered in
            self.infoLabel?.textAlignment = isCentered ? .center : .left
        }).disposed(by: self.disposeBag)
        
        self.viewModel.isBold.asObservable().subscribe(onNext: { [weak self]  isBold in
            
            if isBold {
                self?.infoLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(self?.viewModel.textSize.value ?? 14))
            } else {
                self?.infoLabel?.font = UIFont.systemFont(ofSize: CGFloat(self?.viewModel.textSize.value ?? 14))
            }
            
        }).disposed(by: self.disposeBag)
    }
    
}
