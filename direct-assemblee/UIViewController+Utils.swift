//
//  UIViewController+Utils.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 14/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import UIKit

extension UIViewController {
    
    func add(childViewController:UIViewController, inView view:UIView) {
        self.addChildViewController(childViewController)
        view.add(constraintedSubview: childViewController.view)
        childViewController.didMove(toParentViewController: self)
    }
    
    func removeFromParent() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        self.didMove(toParentViewController: nil)
    }
    
}
