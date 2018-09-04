//
//  LoadingView.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 27/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import NVActivityIndicatorView

class LoadingView: UIView {


    private var activityIndicator: NVActivityIndicatorView!
    
    init(frame: CGRect, loaderColor: UIColor = UIColor(hex:Constants.Color.redColorCode), backgroundColor: UIColor = UIColor.clear, alpha: CGFloat = 1) {
        super.init(frame: frame)
        
        self.backgroundColor = backgroundColor
        self.alpha = alpha
        self.activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        self.activityIndicator.type = .ballClipRotate
        self.activityIndicator.color = loaderColor
        self.activityIndicator.startAnimating()
        self.addCentered(constraintedSubview: self.activityIndicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

}
