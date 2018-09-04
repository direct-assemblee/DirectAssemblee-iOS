//
//  PieChartView.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 02/08/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxSwift


@IBDesignable class PieChartView: UIView {
    
    var elements = [ChartElement]()
    var currentValueIndex = 0
    
    private var sumOfTotalValues = 0
    private var angles = [(start: Double, end: Double)]()
    
    private var centerPoint = CGPoint()
    private var radius:CGFloat = 0.0
    private var elementWidth:CGFloat = 0
    private var referenceAngle:Double = 270
    
    private var elementsLayers = [CAShapeLayer]()
    private var mainLayer = CALayer()
    private var elementsParentLayer = CALayer()
    private var labelsLayer = CALayer()
    
    private var currentElementValueLabel = UILabel()
    private var currentElementTextLabel = UILabel()

    private var startPanGestureTouchedPoint = CGPoint(x: 0, y: 0)
    private var savedPanGestureTransform = CATransform3D()
    private var panGestureStartAngle:CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        
        self.elementWidth = self.frame.size.width / 7
        self.currentValueIndex = 0
        self.backgroundColor = UIColor.clear
        
        self.centerPoint = CGPoint(x: rect.midX, y: rect.midY)
        self.radius = CGFloat(self.frame.size.width/2 - self.elementWidth/2)
        self.sumOfTotalValues = self.elements.map({ element in
            return element.value
        }).reduce(0, +)
        
        self.buildAngles()
        self.buildPaths(inRect:rect)
        self.drawValuesPath(inRect:rect)
        
        self.mainLayer.backgroundColor = UIColor.clear.cgColor
        self.layer.addSublayer(self.mainLayer)

        self.setupLabels()
        self.setupValueIndicator()
        self.setupTopArrowButton()
        self.setupBottomArrowButton()
    
        self.configureGestures()
    }

    
    //MARK: - Rotation
    
    func rotateToNextValue() {
        
        if self.currentValueIndex == 0 {
            self.currentValueIndex = self.elements.count - 1
        } else {
            self.currentValueIndex = self.currentValueIndex - 1
        }
        
        self.rotate(toValueIndex: self.currentValueIndex, animated: true)
    }
    
    func rotateToPreviousValue() {
        
        if self.currentValueIndex == self.elements.count - 1 {
            self.currentValueIndex = 0
        } else {
            self.currentValueIndex = self.currentValueIndex + 1
        }
        
        self.rotate(toValueIndex: self.currentValueIndex, animated: true)
    }
    
    func rotate(toValueIndex valueIndex:Int, animated:Bool, duration:Double) {
        
        guard valueIndex < self.angles.count else {
            return
        }
        
        let startAngle = self.angles[valueIndex].start
        let endAngle = self.angles[valueIndex].end
        let middleAngle = (startAngle + endAngle)/2
        let offset = self.referenceAngle - middleAngle

        CATransaction.begin()
        CATransaction.setValue(duration, forKey: kCATransactionAnimationDuration)
        self.elementsParentLayer.transform = CATransform3DMakeRotation(self.radians(fromDegrees: offset), 0, 0, 1)
        CATransaction.commit()
        
        self.handleRotationToCurrentIndex()
    }
    
    func rotate(toValueIndex valueIndex:Int, animated:Bool) {
        self.rotate(toValueIndex: valueIndex, animated: animated, duration: 0.4)
    }
    
    
    private func handleRotationToCurrentIndex() {
        
        self.currentElementValueLabel.attributedText = self.attributedStringForCurrentValue()
        self.currentElementValueLabel.textColor = self.elements[self.currentValueIndex].color
        
        self.currentElementTextLabel.text = String(self.elements[self.currentValueIndex].label)
        self.currentElementTextLabel.textColor = self.elements[self.currentValueIndex].color
    }
    
    // MARK: - Configuration
    
    private func buildAngles() {
        
        self.angles = [(start: Double, end: Double)]()
        
        for i in 0..<self.elements.count {
            
            let valuePercentage = Double(self.elements[i].value)/Double(self.sumOfTotalValues)
            let angleValue = 360 * Double(valuePercentage)
            let previousValue = (i == 0) ? 0 : self.angles[i-1].end
            
            self.angles.append((start:previousValue, end:previousValue + angleValue))
        }
    }
    
    private func buildPaths(inRect rect: CGRect) {
        
        self.elementsLayers = [CAShapeLayer]()
        
        for angle in self.angles {
            
            let path = UIBezierPath()
            
            path.addArc(withCenter: self.centerPoint,
                        radius: CGFloat(self.radius),
                        startAngle: self.radians(fromDegrees: angle.start),
                        endAngle: self.radians(fromDegrees: angle.end),
                        clockwise: true)
            
            path.cgPath = path.cgPath.copy(strokingWithWidth: self.elementWidth, lineCap: .butt, lineJoin: .miter, miterLimit: 0)
            
            let valueLayer = CAShapeLayer()
            valueLayer.path = path.cgPath
            valueLayer.frame = path.cgPath.boundingBox
            valueLayer.bounds = path.cgPath.boundingBox
            
            self.elementsLayers.append(valueLayer)
        }
    }
    
    private func drawValuesPath(inRect rect: CGRect) {
        
        for i in 0..<self.elementsLayers.count {
            self.elementsLayers[i].fillColor = self.elements[i].color.cgColor
            self.elementsParentLayer.addSublayer(self.elementsLayers[i])
        }
        
        self.elementsParentLayer.backgroundColor = UIColor.clear.cgColor
        self.elementsParentLayer.position = self.centerPoint
        self.elementsParentLayer.frame = self.bounds
        self.elementsParentLayer.bounds = self.bounds
        
        self.mainLayer.addSublayer(self.elementsParentLayer)
        self.mainLayer.position = self.centerPoint
        self.mainLayer.frame = self.bounds
        self.mainLayer.bounds = self.bounds
    }
    
    // MARK: - Labels
    
    private func setupLabels() {
        
        self.labelsLayer = CALayer()
        self.labelsLayer.frame = CGRect(x: self.bounds.origin.x + self.elementWidth,
                                        y: self.bounds.origin.y + self.elementWidth,
                                        width: self.radius*2 - self.elementWidth,
                                        height: self.radius*2 - self.elementWidth)
        self.labelsLayer.bounds = self.labelsLayer.frame
        self.labelsLayer.backgroundColor = UIColor.clear.cgColor
        
        self.mainLayer.addSublayer(self.labelsLayer)
        
        self.setupValueLabel()
        self.setupValueTextLabel()
        
    }
    
    private func setupValueLabel() {
        
        let labelWidth = self.labelsLayer.frame.width - 15
        let labelHeight = CGFloat(22)
        let labelX = CGFloat(self.labelsLayer.frame.midX - labelWidth/2)
        let labelY = CGFloat(self.labelsLayer.frame.midY - labelHeight)
        
        self.currentElementValueLabel = UILabel(frame: CGRect(x: labelX, y: labelY, width:labelWidth, height: labelHeight))
        self.currentElementValueLabel.attributedText = self.attributedStringForCurrentValue()
        self.currentElementValueLabel.textAlignment = .center
        self.currentElementValueLabel.textColor = self.elements[self.currentValueIndex].color
        
        self.labelsLayer.addSublayer(self.currentElementValueLabel.layer)
    }
    
    private func setupValueTextLabel() {
        
        let labelWidth = self.labelsLayer.frame.width - 15
        let labelHeight = CGFloat(22)
        let labelX = CGFloat(self.labelsLayer.frame.midX - labelWidth/2)
        let labelY = CGFloat(self.labelsLayer.frame.midY + 4)
        
        self.currentElementTextLabel = UILabel(frame: CGRect(x: labelX, y: labelY, width:labelWidth, height: labelHeight))
        self.currentElementTextLabel.text = String(self.elements[self.currentValueIndex].label)
        self.currentElementTextLabel.textAlignment = .center
        self.currentElementTextLabel.textColor = self.elements[self.currentValueIndex].color
        self.currentElementTextLabel.numberOfLines = 2
        self.currentElementTextLabel.font = UIFont.systemFont(ofSize: 16)
        
        self.labelsLayer.addSublayer(self.currentElementTextLabel.layer)
    }
    
    // MARK: - Change element buttons

    private func setupTopArrowButton() {
    
        let arrowPath = UIBezierPath()
        
        arrowPath.addArc(withCenter: self.centerPoint,
                         radius: CGFloat(self.radius - self.elementWidth/2 - 20),
                         startAngle: self.radians(fromDegrees: -150),
                         endAngle: self.radians(fromDegrees: -30),
                         clockwise: true)
        
        let startArrowPoint = CGPoint(x: arrowPath.currentPoint.x+1, y: arrowPath.currentPoint.y+1)
        
        arrowPath.addLine(to: CGPoint(x: startArrowPoint.x - 18, y: startArrowPoint.y - 5))
        arrowPath.move(to: startArrowPoint)
        arrowPath.addLine(to: CGPoint(x: startArrowPoint.x, y: startArrowPoint.y - 20))
        
        let button = self.getChangeElementButton(withPath: arrowPath)
        button.addTarget(self, action: #selector(onNextButtonTouch), for: .touchUpInside)
        self.addSubview(button)
    }
    
    private func setupBottomArrowButton() {
        
        let arrowPath = UIBezierPath()
        
        arrowPath.addArc(withCenter: self.centerPoint,
                         radius: CGFloat(self.radius - self.elementWidth/2 - 20),
                         startAngle: self.radians(fromDegrees: 150),
                         endAngle: self.radians(fromDegrees: 30),
                         clockwise: false)
        
        
        let startArrowPoint = CGPoint(x: arrowPath.currentPoint.x+1, y: arrowPath.currentPoint.y-1)
        
        arrowPath.addLine(to: CGPoint(x: startArrowPoint.x - 18, y: startArrowPoint.y + 5))
        arrowPath.move(to: startArrowPoint)
        arrowPath.addLine(to: CGPoint(x: startArrowPoint.x, y: startArrowPoint.y + 20))
        
        let button = self.getChangeElementButton(withPath: arrowPath)
        button.addTarget(self, action: #selector(onPreviousButtonTouch), for: .touchUpInside)
        self.addSubview(button)
    }
    
    private func getChangeElementButton(withPath path:UIBezierPath) -> UIButton {
        
        let arrowLayer = CAShapeLayer()
        arrowLayer.path = path.cgPath
        arrowLayer.frame = path.cgPath.boundingBox
        arrowLayer.bounds = path.cgPath.boundingBox
        arrowLayer.fillColor = UIColor.clear.cgColor
        arrowLayer.strokeColor = UIColor.gray.cgColor
        arrowLayer.lineWidth = 2
        
        let button = UIButton(type: .custom)
        button.frame = arrowLayer.frame
        button.bounds = arrowLayer.bounds
        button.layer.addSublayer(arrowLayer)
        
        return button
    }

    // MARK: - Arrow indicator
    
    private func setupValueIndicator() {
        
        let indicatorPath = UIBezierPath()
        indicatorPath.move(to: CGPoint(x: self.centerPoint.x - 12, y: 0))
        indicatorPath.addLine(to: CGPoint(x: self.centerPoint.x + 12, y: 0))
        indicatorPath.addLine(to: CGPoint(x: self.centerPoint.x, y: CGFloat(self.elementWidth/2)))
        indicatorPath.close()
        
        let indicatorLayer = CAShapeLayer()
        indicatorLayer.path = indicatorPath.cgPath
        indicatorLayer.frame = indicatorPath.cgPath.boundingBox
        indicatorLayer.bounds = indicatorPath.cgPath.boundingBox
        indicatorLayer.fillColor = UIColor.white.cgColor
        
        self.mainLayer.addSublayer(indicatorLayer)
    }
    
    
    //MARK: - Actions
    
    @objc func onNextButtonTouch(sender:Any) {
        self.rotateToNextValue()
    }
    
    @objc func onPreviousButtonTouch(sender:Any) {
        self.rotateToPreviousValue()
    }
    
    
    // MARK: - Gestures
    
    private func configureGestures() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onUserTap))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.onUserPan))
        
        self.gestureRecognizers = [tapGesture, panGesture]
    }
    
    @objc func onUserTap(gestureRecognizer:UITapGestureRecognizer) {
        
        let touchedPoint = gestureRecognizer.location(in: self)
        let convertedTappedPoint = self.layer.convert(touchedPoint, to: self.elementsParentLayer)
        
        if let index = self.layerIndex(forPoint: convertedTappedPoint) {
            self.currentValueIndex = index
            self.rotate(toValueIndex: self.currentValueIndex, animated: true)
        }
    }
    @objc func onUserPan(gestureRecognizer:UIPanGestureRecognizer) {

        if gestureRecognizer.state == .began {
            self.handleStartPanGesture(gestureRecognizer)
        } else if gestureRecognizer.state == .changed {
            self.handleChangedPanGesture(gestureRecognizer)
        } else if gestureRecognizer.state == .ended {
            self.handleEndPanGesture(gestureRecognizer)
        }
    }
    
    private func handleStartPanGesture(_ gestureRecognizer:UIPanGestureRecognizer) {
        self.startPanGestureTouchedPoint = gestureRecognizer.location(in: self)
        self.savedPanGestureTransform = self.elementsParentLayer.transform
        self.panGestureStartAngle = atan2(self.startPanGestureTouchedPoint.y - self.centerPoint.y, self.startPanGestureTouchedPoint.x - self.centerPoint.x)
    }
    
    private func handleChangedPanGesture(_ gestureRecognizer:UIPanGestureRecognizer) {
        
        let translationX = gestureRecognizer.translation(in: self).x
        let translationY = gestureRecognizer.translation(in: self).y
        
        let offsetX = translationX + self.startPanGestureTouchedPoint.x - self.centerPoint.x
        let offsetY = translationY + self.startPanGestureTouchedPoint.y - self.centerPoint.y
        
        let angle = atan2(offsetY, offsetX)
        let deltaAngle = angle - self.panGestureStartAngle
        
        self.elementsParentLayer.transform = CATransform3DRotate(self.savedPanGestureTransform, deltaAngle, 0, 0, 1)
    }
    
    private func handleEndPanGesture(_ gestureRecognizer:UIPanGestureRecognizer) {
        
        let currentAngle = self.degrees(fromRadians: self.elementsParentLayer.value(forKeyPath: "transform.rotation.z") as! Double)
        var finalAngle:CGFloat = 0
        
        if currentAngle >= 0 && currentAngle <= 180 {
            finalAngle = CGFloat(self.referenceAngle) - currentAngle
        } else if currentAngle < 0 && currentAngle >= -180 {
            let offset = 180 - abs(currentAngle)
            finalAngle = CGFloat(self.referenceAngle) - (180 + offset)
        }
        
        if finalAngle < 0 {
            finalAngle = 360 + finalAngle
        }

        guard let index = self.angles.index(where: { (start, end) in
            return Double(finalAngle) >= start && Double(finalAngle) <= end
        }) else {
            return
        }
        
        self.currentValueIndex = index
        self.rotate(toValueIndex: index, animated: true)
    }

    // MARK: - Private helpers
    
    private func layerIndex(forPoint point:CGPoint) -> Int? {
        
        for subLayer in self.elementsLayers {
            if subLayer.path?.contains(point) == true {
                if let index = self.elementsLayers.index(of: subLayer) {
                    return index
                }
            }
        }
        
        return nil
    }

    private func attributedStringForCurrentValue() -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(string: "")
        
        let valueString = NSMutableAttributedString(string: "\(self.elements[self.currentValueIndex].value)", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 26)])
        let totalString = NSMutableAttributedString(string: " / \(self.sumOfTotalValues)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)])
        
        attributedString.append(valueString)
        attributedString.append(totalString)
        
        return attributedString
    }
    
    fileprivate func radians(fromDegrees degrees: Double) -> CGFloat {
        return (CGFloat(degrees)*CGFloat(Double.pi))/180
    }
    
    fileprivate func degrees(fromRadians radians: Double) -> CGFloat {
        return CGFloat(radians*(180/Double.pi))
    }
}
