//
//  AlertCellView.swift
//  Panther
//
//  Created by Mark Jackson on 9/24/15.
//  Copyright © 2015 Mark Jackson. All rights reserved.
//

import UIKit

@IBDesignable class AlertTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var roundedView: AlertRoundedView!
    @IBOutlet weak var bellImage: UIImageView!
    @IBOutlet weak var switchBtn: UISwitch!
    @IBAction func switchChanged(sender: AnyObject) {
        if(switchBtn.on){
            applyAlphaToAllViews(1)
        }else{
            applyAlphaToAllViews(0.57)
        }
    }
    
    func applyAlphaToAllViews(alpha: CGFloat){
        switchBtn.alpha = alpha
        titleLabel.alpha = alpha
        bellImage.alpha = alpha
        roundedView.alpha = alpha
    }
   
}
