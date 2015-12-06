//
//  ParkingIndicatorCircleView.swift
//  Panther
//
//  Created by Mark Jackson on 9/21/15.
//  Copyright © 2015 Mark Jackson. All rights reserved.
//

import UIKit

@IBDesignable class FilledCircleIndicatorView: UIView {
    
    private var angleOffset : CGFloat = 0.1
    
    let circleLineWidth : CGFloat = 1
    
    
    var color : UIColor = UIColor.blackColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.setNeedsDisplay()
//        for circleLayer in self.layer.sublayers!{
//            if(circleLayer.name == "circle"){
//                circleLayer.removeFromSuperlayer()
//            }
//        }
    }
    
    
    func setCapacityLevel(currentCapacity : CGFloat, outOfTotalCapacity totalCapacity : CGFloat){
        let percentage = currentCapacity / totalCapacity
        angleOffset = percentage * 179.9
        //TODO: Fix so that the colors are customizable
        if(angleOffset < 0.1){
            angleOffset = 0.1
        } else if (angleOffset > 179.9){
            angleOffset = 179.9
        }
        if(angleOffset > (0.2 * 179.9)){
            color = Constants.Colors.GREEN_COLOR
        }else{
            color = Constants.Colors.RED_COLOR
        }
    }

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let ref  = UIGraphicsGetCurrentContext()
        CGContextSaveGState(ref)
        
        let chosenColor : UIColor = color
        chosenColor.setFill()
        
        let path : UIBezierPath = UIBezierPath(arcCenter: CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect)), radius: CGRectGetMidX(rect) - circleLineWidth / 2 - 1, startAngle: degreesToRadians(270 + angleOffset), endAngle: degreesToRadians(270 - angleOffset), clockwise: true)
        
        
//        let path : UIBezierPath = UIBezierPath()
//        path.moveToPoint(CGPointMake(0, self.frame.height / 2))
//        path.moveToPoint(CGPointMake(self.frame.width, self.frame.height / 2))
//        path.addArcWithCenter(CGPointMake(self.frame.width / 2, 0), radius: self.frame.width / 2, startAngle: 0, endAngle: degreesToRadians(360), clockwise: true)
        
        path.fill()
        
        let strokePath : UIBezierPath = UIBezierPath(roundedRect: CGRectInset(rect, circleLineWidth / 2, circleLineWidth / 2), cornerRadius: 100)
        strokePath.lineWidth = circleLineWidth
        chosenColor.setStroke()
        strokePath.stroke()
        
        //Old way
//        let circleLayer : CAShapeLayer = CAShapeLayer()
//        // Give the layer the same bounds as your image view
//        circleLayer.bounds = CGRectMake(2, 2, self.frame.width - 4, self.frame.height - 4)
//        // Position the circle anywhere you like, but this will center it
//        // In the parent layer, which will be your image view's root layer
//        circleLayer.position = CGPointMake(self.frame.width / 2, self.frame.height / 2)
//        // Create a circle path.
//        let circlePath : UIBezierPath = UIBezierPath(ovalInRect: CGRectMake(2, 2, self.frame.width - 4, self.frame.height - 4))
//        // Set the path on the layer
//        circleLayer.path = circlePath.CGPath
//        // Set the stroke color
//        circleLayer.strokeColor = chosenColor.CGColor
//        // Set the stroke line width
//        circleLayer.lineWidth = circleLineWidth
//        circleLayer.fillColor = UIColor.clearColor().CGColor
//        circleLayer.name = "circle"
//        
//        // Add the sublayer to the image view's layer tree
//        self.layer.addSublayer(circleLayer)
        
        CGContextRestoreGState(ref)
    }
    
    func degreesToRadians(degrees : CGFloat) -> CGFloat{
        let pi : CGFloat = 3.14159265359
        let radians : CGFloat = ((pi * degrees) / 180)
        return radians
    }
    

}
