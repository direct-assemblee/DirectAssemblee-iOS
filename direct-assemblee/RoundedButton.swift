//
//  RoundedButton.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 12/12/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit

class RoundedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupStyle()
    }
    
    private func setupStyle() {

        self.layer.borderColor = UIColor(hex: Constants.Color.redColorCode).cgColor
        self.tintColor = UIColor(hex: Constants.Color.redColorCode)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }

}
