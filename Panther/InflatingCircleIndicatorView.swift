//
//  InflatingCircleIndicatorView.swift
//  Panther
//
//  Created by Mark Jackson on 9/24/15.
//  Copyright © 2015 Mark Jackson. All rights reserved.
//

import UIKit

@IBDesignable class InflatingCircleIndicatorView: UIView {
    
    var baseColor : UIColor = Constants.Colors.BASE_COLOR
    var fillColor : UIColor = Constants.Colors.GREEN_COLOR
    
    private var amountFilled : CGFloat = 10

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setCapacityLevel(currentCapacity : CGFloat, outOfTotalCapacity totalCapacity : CGFloat){
        let percentage = currentCapacity / totalCapacity
        amountFilled = percentage * self.frame.width / 2
        //TODO: Fix so that the colors are customizable
        if(1 - percentage >= 0.85){
            fillColor = Constants.Colors.RED_COLOR
        }else if(1 - percentage >= 0.55){
            fillColor = Constants.Colors.YELLOW_COLOR
        }else{
            fillColor = Constants.Colors.GREEN_COLOR
        }
        
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
//        let ref  = UIGraphicsGetCurrentContext()
        
        let outerColor : UIColor = baseColor
        outerColor.setFill()
        
        let basePath : UIBezierPath = UIBezierPath(ovalInRect: CGRectInset(rect, 1, 1))
        basePath.fill()
        
        let innerColor : UIColor = fillColor
        innerColor.setFill()
        
        let innerPath : UIBezierPath = UIBezierPath(ovalInRect: CGRectInset(rect, amountFilled, amountFilled))
        innerPath.fill()
        
//
//        CGContextRestoreGState(ref)
    }


}
