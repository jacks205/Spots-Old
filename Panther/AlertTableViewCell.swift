//
//  AlertCellView.swift
//  Panther
//
//  Created by Mark Jackson on 9/24/15.
//  Copyright © 2015 Mark Jackson. All rights reserved.
//

import UIKit

@IBDesignable class AlertTableViewCell: UITableViewCell {
    
    var alert : Alert?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var roundedView: AlertRoundedView!
    @IBOutlet weak var bellImage: UIImageView!
    @IBOutlet weak var switchBtn: UISwitch!
    
    func setAlert(alert: Alert){
        self.alert = alert
        titleLabel.text = "\(alert.day)".lowercaseString.capitalizedString +  "s @ " + alert.getTimeString()
        setEnabled(alert.enabled)
    }
    
    @IBAction func switchChanged(sender: AnyObject) {
        setEnabled(switchBtn.on)
    }
    
    func setEnabled(enabled : Bool){
        if let a = alert {
            a.enabled = enabled
        }
        switchBtn.on = enabled
        if(enabled){
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
