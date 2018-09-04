//
//  DeputyDetailSectionView.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 19/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit

class DeputyDetailSectionView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.separatorView.backgroundColor = UIColor(hex: Constants.Color.blueColorCode)
    }
    
}
