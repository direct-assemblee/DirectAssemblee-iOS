//
//  BaseTableViewCell.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 16/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxSwift

class BaseTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
}

class BaseCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
}

class DeputyDetailBaseTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    
    var viewModel:DeputyDetail?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupColors()
    }
    
    private func setupColors() {
        self.selectedBackgroundView = UIView(frame: self.frame)
        self.selectedBackgroundView?.backgroundColor = UIColor(hex: Constants.Color.blueLightColorCode)
    }
    
}

