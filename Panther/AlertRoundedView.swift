//
//  AlertRoundedView.swift
//  Panther
//
//  Created by Mark Jackson on 9/24/15.
//  Copyright © 2015 Mark Jackson. All rights reserved.
//

import UIKit

@IBDesignable class AlertRoundedView: UIView {
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let color : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.17)
        
        color.setFill()
        
        let path : UIBezierPath = UIBezierPath(roundedRect: CGRectInset(rect, 1, 1), cornerRadius: 4)
        
        path.fill()
        
    }
    

}
