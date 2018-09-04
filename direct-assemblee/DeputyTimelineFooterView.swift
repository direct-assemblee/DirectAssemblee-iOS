
//
//  DeputyTimelineFooterView.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 14/12/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit

class DeputyTimelineFooterView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.add(constraintedSubview: LoadingView(frame: self.frame))
    }

}
