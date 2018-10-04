
//
//  ProgressBarView.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 04/10/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//

import UIKit

class ProgressBarView: UIView {

    var progress: Float = 0
    var progressTintColor = UIColor(hex: Constants.Color.blueColorCode)
    var trackTintColor = UIColor(hex: Constants.Color.blueLightColorCode)

    override func draw(_ rect: CGRect) {
        
        let trackLayer = self.getTrackLayer()
        self.layer.addSublayer(trackLayer)
        
        let progressLayer = self.getProgressLayer()
        self.layer.addSublayer(progressLayer)
        self.animatesLayer(progressLayer)
    }
    
    private func getProgressLayer() -> CAShapeLayer {
        
        let width = CGFloat(self.progress) * self.bounds.width
        let progressLayer =  self.getBarLayer(width: width)
        progressLayer.fillColor = self.progressTintColor.cgColor
        
        return progressLayer
    }
    
    private func getTrackLayer() -> CAShapeLayer {
        
        let trackLayer =  self.getBarLayer(width: self.bounds.width)
        trackLayer.fillColor = self.trackTintColor.cgColor
        
        return trackLayer
    }
    
    private func getBarLayer(width: CGFloat) -> CAShapeLayer {
        
        let rect = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: width, height: self.bounds.height)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 5)
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.frame = path.cgPath.boundingBox
        layer.bounds = path.cgPath.boundingBox
        
        return layer
    }
    
    private func animatesLayer(_ layer: CAShapeLayer) {
    
        let fromRect = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: 0, height: self.bounds.height)
        let fromPath = UIBezierPath(rect: fromRect)
        let toPath = layer.path
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = fromPath
        animation.toValue = toPath
        animation.duration = 2
        animation.beginTime = 1
        
        layer.add(animation, forKey: "draw")
        
    }


}