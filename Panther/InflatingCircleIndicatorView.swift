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
    
    private var amountFilled : CGFloat = 25
    
    var circleLayer : CAShapeLayer?
    var firstPath : UIBezierPath?
    var secondPath : UIBezierPath?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func animateCircle(delay: CFTimeInterval){
        circleLayer!.frame = bounds
        circleLayer!.fillColor = fillColor.CGColor
        circleLayer!.path = firstPath!.CGPath
//        firstPath = UIBezierPath(CGPath: (secondPath?.CGPath)!)
        
        let anim : CABasicAnimation = CABasicAnimation(keyPath: "path")
        //        anim2.repeatCount = 0
        anim.duration = 0.35
        anim.toValue = secondPath!.CGPath
        anim.removedOnCompletion = false
        anim.fillMode = kCAFillModeBoth
        anim.beginTime = CACurrentMediaTime() + delay
        
        anim.timingFunction = CAMediaTimingFunction(controlPoints: 0.23, 1.0, 0.32, 1.0)
        circleLayer!.addAnimation(anim, forKey: anim.keyPath)
        
        
    }
    
    func setCapacityLevel(currentCapacity : CGFloat, outOfTotalCapacity totalCapacity : CGFloat){
        let percentage = currentCapacity / totalCapacity
        //original: amountFilled = percentage * self.frame.width / 2
        amountFilled = (1 - percentage) * self.frame.width / 2
        if(percentage < 0.1){
            amountFilled = 0.9 * self.frame.width / 2
        }
        //TODO: Fix so that the colors are customizable
        if(1 - percentage >= 0.85){
            fillColor = Constants.Colors.RED_COLOR
        }else if(1 - percentage >= 0.55){
            fillColor = Constants.Colors.YELLOW_COLOR
        }else{
            fillColor = Constants.Colors.GREEN_COLOR
        }
        secondPath = UIBezierPath(ovalInRect: CGRectInset(bounds, amountFilled, amountFilled))
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        //Outer Circle
        let outerColor : UIColor = baseColor
        outerColor.setFill()
        let basePath : UIBezierPath = UIBezierPath(ovalInRect: CGRectInset(rect, 1, 1))
        basePath.fill()
        
        //Inner circle
        let innerColor : UIColor = fillColor
        if let _ = firstPath {
        }else{
            firstPath = UIBezierPath(ovalInRect: CGRectInset(rect, rect.width / 2, rect.height / 2))
        }
        
        if let _ = circleLayer {
        }else{
            circleLayer = CAShapeLayer()
//            circleLayer?.name = "circle"
            layer.addSublayer(circleLayer!)
        }
        
        circleLayer!.frame = bounds
        circleLayer!.fillColor = innerColor.CGColor
        circleLayer!.path = firstPath!.CGPath
        
        if let _ = secondPath {
        }else{
            secondPath = UIBezierPath(ovalInRect: CGRectInset(bounds, amountFilled, amountFilled))
        }
        //        animateCircle()
//        let anim : CABasicAnimation = CABasicAnimation(keyPath: "path")
//        //        anim2.repeatCount = 0
//        anim.duration = 2
//        anim.toValue = secondPath?.CGPath
//        anim.removedOnCompletion = false
//        anim.fillMode = kCAFillModeBoth
//        
//        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//        
//        circleLayer!.addAnimation(anim, forKey: anim.keyPath)
        
//        firstPath = UIBezierPath(CGPath: secondPath!.CGPath)
        
    }


}
