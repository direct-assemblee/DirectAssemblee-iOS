//
//  PlaceholderView.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 23/04/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxSwift

class PlaceholderView: UIView {
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var refreshButton: RoundedButton!
    
    var refreshAction: (() -> Void)?
    
    static func create(refreshAction: @escaping (() -> Void)) -> PlaceholderView? {
        
        let placeholderView = R.nib.placeholderView.firstView(owner: self)
        
        placeholderView?.refreshButton.setTitle(R.string.localizable.reload(), for: .normal)
        placeholderView?.refreshAction = refreshAction
        
        return placeholderView
    }
    
    static func initWithLabel(_ label: String, refreshAction: @escaping (() -> Void)) -> PlaceholderView? {
        
        let placeholderView = PlaceholderView.create(refreshAction: refreshAction)
        placeholderView?.message.text = label
        return placeholderView
    }
    
    static func initWithError(_ error: DAError, refreshAction: @escaping (() -> Void)) -> PlaceholderView? {
        
        let placeholderView = R.nib.placeholderView.firstView(owner: self)
        placeholderView?.message.text = error.description
        return placeholderView
    }
    
    @IBAction func onRefreshTap(_ sender: Any) {
        guard let refreshAction = self.refreshAction else {
            return
        }
        
        refreshAction()
    }
    
    
    
}
