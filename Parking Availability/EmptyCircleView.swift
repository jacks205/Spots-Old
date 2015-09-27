//
//  EmptyCircleView
//
//  Created by Mark Jackson on 9/27/15.
//  Copyright © 2015 Mark Jackson. All rights reserved.
//

import UIKit

@IBDesignable class EmptyCircleView: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let clip : UIBezierPath = UIBezierPath(ovalInRect: CGRectInset(rect, 6, 6))
        clip.addClip()
        UIColor(white: 1, alpha: 0.09).setStroke()
        let path : UIBezierPath = UIBezierPath()
        path.lineWidth = 1
        let increments: CGFloat = rect.height / 8
        var j: CGFloat = increments
        for _ in 0...8{
            path.moveToPoint(CGPointMake(j, 0))
            path.addLineToPoint(CGPointMake(j, rect.height))
            j += increments
            
        }
        path.stroke()
        
        
        self.transform = CGAffineTransformMakeRotation(CGFloat(-1 * M_PI_4))
        
    }

}
