//
//  UINotificationButton.swift
//  Panther
//
//  Created by Mark Jackson on 9/24/15.
//  Copyright © 2015 Mark Jackson. All rights reserved.
//

import UIKit

@IBDesignable class UINotificationButton: UIButton {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let path : UIBezierPath = UIBezierPath(roundedRect: CGRectInset(self.bounds, 0.5, 0.5), cornerRadius: 40)
        path.lineWidth = 1
        UIColor.whiteColor().setStroke()
        path.stroke()
        
    }
    

}
