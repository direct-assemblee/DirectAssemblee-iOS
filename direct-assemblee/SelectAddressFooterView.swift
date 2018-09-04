//
//  SelectAddressFooterView.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 26/06/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit

class SelectAddressFooterView: UIView {
    
    @IBOutlet weak var poweredByLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.poweredByLabel.text = R.string.localizable.powered_by()
    }
}
