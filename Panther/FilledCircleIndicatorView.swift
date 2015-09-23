//
//  ParkingIndicatorCircleView.swift
//  Panther
//
//  Created by Mark Jackson on 9/21/15.
//  Copyright © 2015 Mark Jackson. All rights reserved.
//

import UIKit

@IBDesignable class FilledCircleIndicatorView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let ref  = UIGraphicsGetCurrentContext()
        CGContextSaveGState(ref)
        
        let color : UIColor = UIColor(CGColor: UIColor(red:0.16, green:0.93, blue:0.70, alpha:1.0).CGColor)
        color.setFill()
        
        let path : UIBezierPath = UIBezierPath(arcCenter: CGPointMake(self.frame.width / 2, self.frame.height / 2), radius: (self.frame.width / 2) - 4, startAngle: degreesToRadians(45), endAngle: degreesToRadians(180 - 45), clockwise: true)
        
        
//        let path : UIBezierPath = UIBezierPath()
//        path.moveToPoint(CGPointMake(0, self.frame.height / 2))
//        path.moveToPoint(CGPointMake(self.frame.width, self.frame.height / 2))
//        path.addArcWithCenter(CGPointMake(self.frame.width / 2, 0), radius: self.frame.width / 2, startAngle: 0, endAngle: degreesToRadians(360), clockwise: true)
        
        path.fill()
        
        let circleLayer : CAShapeLayer = CAShapeLayer()
        // Give the layer the same bounds as your image view
        circleLayer.bounds = CGRectMake(2, 2, self.frame.width - 4, self.frame.height - 4)
        // Position the circle anywhere you like, but this will center it
        // In the parent layer, which will be your image view's root layer
        circleLayer.position = CGPointMake(self.frame.width / 2, self.frame.height / 2)
        // Create a circle path.
        let circlePath : UIBezierPath = UIBezierPath(ovalInRect: CGRectMake(2, 2, self.frame.width - 4, self.frame.height - 4))
        // Set the path on the layer
        circleLayer.path = circlePath.CGPath
        // Set the stroke color
        circleLayer.strokeColor = UIColor(red:0.16, green:0.93, blue:0.70, alpha:1.0).CGColor
        // Set the stroke line width
        circleLayer.lineWidth = 1
        circleLayer.fillColor = UIColor.clearColor().CGColor
        
        // Add the sublayer to the image view's layer tree
        self.layer.addSublayer(circleLayer)
        
        CGContextRestoreGState(ref)
    }
    
    func degreesToRadians(degrees : CGFloat) -> CGFloat{
        let pi : CGFloat = 3.14159265359
        let radians : CGFloat = ((pi * degrees) / 180)
        return radians
    }
    

}
