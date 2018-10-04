//
//  BarChartView.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 06/12/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit

struct ChartElement {
    
    var value:Int = 0
    var color:UIColor = UIColor.white
    var label:String = ""
    
    init(value:Int, color:UIColor, label:String) {
        self.value = value
        self.color = color
        self.label = label
    }
    
}
class BarChartView: UIView {
    
    var elements = [ChartElement]()
    
    private var sumOfTotalValues = 0
    private var rectanglesLayers = [CAShapeLayer]()
    
    private var graphElementWidth:CGFloat = 0
    private var graphElementSpacer:CGFloat = 0
    
    private var maximumRectangleHeight:CGFloat = 0
    private let valueLabelHeight:CGFloat = 22
    private let textLabelHeight:CGFloat = 44
    private let labelsTextSize:CGFloat = 14
    
    override func draw(_ rect: CGRect) {
        self.configure()
        self.drawGraph()
    }
    
    private func configure() {
        
        self.sumOfTotalValues = self.elements.map({ element in
            return element.value
        }).reduce(0, +)
        
        self.graphElementWidth = (self.frame.width / CGFloat(self.elements.count)) * CGFloat(0.85)
        self.graphElementSpacer = (self.frame.width - self.graphElementWidth * CGFloat(self.elements.count)) / CGFloat(self.elements.count - 1)
        self.maximumRectangleHeight = self.frame.height - self.textLabelHeight - self.valueLabelHeight
    }
    
    private func drawGraph() {
        
        self.drawBottomLine()
        
        for i in 0..<self.elements.count {
            
            let height = (CGFloat(self.elements[i].value) / CGFloat(self.sumOfTotalValues)) * self.maximumRectangleHeight
            let positionX = CGFloat(i) * (self.graphElementWidth + self.graphElementSpacer)
            let rectanglePositionY = self.frame.height - self.textLabelHeight - height
            let positionValueLabelY = rectanglePositionY - self.valueLabelHeight
            let positionTextLabelY = self.frame.height - self.textLabelHeight
            let color = self.elements[i].color
            let textLabelValue = self.elements[i].label
            let valueLabelValue = self.elements[i].value
            
            self.drawAnimatedRectangle(coordinates: CGPoint(x: positionX, y: rectanglePositionY), height: CGFloat(height), color:color)
            self.drawValueLabel(coordinates: CGPoint(x: positionX, y: positionValueLabelY), color: color, value: valueLabelValue)
            self.drawTextLabel(coordinates: CGPoint(x: positionX, y: positionTextLabelY), color: UIColor(hex: Constants.Color.blackColorCode), text: textLabelValue)
        }
    }
    
    private func drawBottomLine() {
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: self.frame.height - self.textLabelHeight))
        linePath.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height - self.textLabelHeight))
        linePath.close()
        
        let linePathLayer = CAShapeLayer()
        linePathLayer.path = linePath.cgPath
        linePathLayer.frame = linePath.cgPath.boundingBox
        linePathLayer.bounds = linePath.cgPath.boundingBox
        linePathLayer.strokeColor = UIColor(hex: "CFD1D1").cgColor
        linePathLayer.lineWidth = 1.0
        
        self.layer.insertSublayer(linePathLayer, at: 0)
        
    }
    
    private func drawAnimatedRectangle(coordinates:CGPoint, height:CGFloat, color:UIColor) {
        
        let rectanglePath = UIBezierPath(rect: CGRect(x: coordinates.x, y: coordinates.y, width: self.graphElementWidth, height: height))
        
        let rectangleLayer = CAShapeLayer()
        rectangleLayer.path = rectanglePath.cgPath
        rectangleLayer.frame = rectanglePath.cgPath.boundingBox
        rectangleLayer.bounds = rectanglePath.cgPath.boundingBox
        rectangleLayer.fillColor = color.cgColor
        
        self.rectanglesLayers.append(rectangleLayer)
        self.layer.addSublayer(rectangleLayer)
        
        self.animateRectangle(rectangleLayer)
        
    }
    
    private func drawValueLabel(coordinates:CGPoint, color:UIColor, value:Int) {
        
        let textLabel = UILabel(frame: CGRect(x: coordinates.x, y: coordinates.y, width:self.graphElementWidth, height: self.valueLabelHeight))
        textLabel.text = String(value)
        textLabel.textAlignment = .center
        textLabel.textColor = color
        textLabel.numberOfLines = 2
        textLabel.font = UIFont.systemFont(ofSize: self.labelsTextSize)
        
        self.addSubview(textLabel)
    }
    
    private func drawTextLabel(coordinates:CGPoint, color:UIColor, text:String) {
        
        let textLabel = UILabel(frame: CGRect(x: coordinates.x - 2, y: coordinates.y, width:self.graphElementWidth  + 4, height: self.textLabelHeight))
        textLabel.text = text
        textLabel.textAlignment = .center
        textLabel.textColor = color
        textLabel.numberOfLines = 2
        textLabel.font = UIFont.systemFont(ofSize: self.labelsTextSize)
        
        self.addSubview(textLabel)
    }
    
    private func animateRectangle(_ rectangleLayer:CAShapeLayer) {
        
        let startPath = UIBezierPath(rect: CGRect(x: rectangleLayer.frame.origin.x, y: rectangleLayer.frame.origin.y + rectangleLayer.frame.height, width: rectangleLayer.frame.width, height: 0)).cgPath
        let endPath = rectangleLayer.path
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = startPath
        animation.toValue = endPath
        animation.duration = 0.4
        
        rectangleLayer.add(animation, forKey: "draw")
    }
    
}
