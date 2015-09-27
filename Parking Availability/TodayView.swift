//
//  TodayView.swift
//  TodayExtensionTest
//
//  Created by Mark Jackson on 9/27/15.
//  Copyright © 2015 Mark Jackson. All rights reserved.
//

import UIKit

@IBDesignable class TodayView: UIView {
    
    var baseColor : UIColor = UIColor(white: 1, alpha: 0.1)
    var fillColor : UIColor = UIColor(red:0.10, green:0.74, blue:0.61, alpha:1.0)
    
    private var amountFilled : CGFloat = 10
    
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
        let outerColor : UIColor = baseColor
        outerColor.setFill()
        
        let basePath : UIBezierPath = UIBezierPath(ovalInRect: CGRectInset(rect, 1, 1))
        basePath.fill()
        
        let innerColor : UIColor = fillColor
        innerColor.setFill()
        
        let innerPath : UIBezierPath = UIBezierPath(ovalInRect: CGRectInset(rect, amountFilled, amountFilled))
        innerPath.fill()
    }


}
