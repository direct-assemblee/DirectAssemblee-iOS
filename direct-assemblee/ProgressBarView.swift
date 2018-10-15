
//
//  ProgressBarView.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 04/10/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//

import UIKit

@IBDesignable class ProgressBarView: UIView {

    @IBInspectable var progress: Float = 0
    @IBInspectable var progressTintColor: UIColor = UIColor(hex: Constants.Color.blueColorCode)
    @IBInspectable var trackTintColor: UIColor = UIColor(hex: Constants.Color.blueLightColorCode)
    
    private var trackLayer: CAShapeLayer {
        
        let trackLayer =  self.getBarLayer(width: self.bounds.size.width)
        trackLayer.fillColor = self.trackTintColor.cgColor
        
        return trackLayer
    }
    
    private var progressLayer: CAShapeLayer {
        
        let width = CGFloat(self.progress) * self.bounds.size.width
        let progressLayer =  self.getBarLayer(width: width)
        progressLayer.fillColor = self.progressTintColor.cgColor
        
        return progressLayer
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupView()
    }
    
    private func setupView() {
        let trackLayer = self.trackLayer
        self.layer.addSublayer(trackLayer)
        
        let progressLayer = self.progressLayer
        self.layer.addSublayer(progressLayer)
        
        #if !TARGET_INTERFACE_BUILDER
            self.animatesLayer(progressLayer)
        #endif
    }
    

    private func getBarLayer(width: CGFloat) -> CAShapeLayer {
        
        let rect = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: width, height: self.bounds.size.height)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 5)
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.frame = path.cgPath.boundingBox
        layer.bounds = path.cgPath.boundingBox
        
        return layer
    }
    
    private func animatesLayer(_ layer: CAShapeLayer) {
    
        let fromRect = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: 0, height: self.bounds.size.height)
        let fromPath = UIBezierPath(roundedRect: fromRect, cornerRadius: 5).cgPath
        let toPath = layer.path
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = fromPath
        animation.toValue = toPath
        animation.duration = 0.4
        
        layer.add(animation, forKey: "draw")
        
    }


}
