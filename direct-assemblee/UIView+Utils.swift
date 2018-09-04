//
//  UIView+Utils.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 14/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import UIKit

extension UIView {
    
    func addCentered(constraintedSubview subview:UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: subview, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: subview, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: subview.frame.width))
        self.addConstraint(NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: subview.frame.height))
    }
    
    func add(constraintedSubview subview:UIView) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: subview, attribute: .left, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: subview, attribute: .right, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: subview, attribute: .top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: subview, attribute: .bottom, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: subview, attribute: .width, multiplier: 1, constant: 0))
    }
    
    func addLoadingView(loaderColor: UIColor = UIColor(hex:Constants.Color.redColorCode), backgroundColor: UIColor = UIColor.clear, alpha: CGFloat = 1) {
        let loadingView = LoadingView(frame: self.frame, loaderColor: loaderColor, backgroundColor: backgroundColor, alpha: alpha)
        self.add(constraintedSubview: loadingView)
    }
    
    func removeLoadingView() {
        
        for subview in self.subviews {
            if subview is LoadingView {
                subview.removeFromSuperview()
            }
        }
    }
    
    func addPlaceholderView(label: String, onRefresh: @escaping (() -> Void)) {
        
        guard let placeholderView = PlaceholderView.initWithLabel(label, refreshAction: onRefresh) else {
            return
        }
        
        self.add(constraintedSubview: placeholderView)
    }
    
    func addPlaceholderView(error: DAError, onRefresh: @escaping (() -> Void)) {
       
        guard let placeholderView = PlaceholderView.initWithError(error, refreshAction: onRefresh) else {
            return
        }
        
        self.add(constraintedSubview: placeholderView)
    }
    
    func removePlaceholderView() {
        
        for subview in self.subviews {
            if subview is PlaceholderView {
                subview.removeFromSuperview()
            }
        }
    }
    
}
