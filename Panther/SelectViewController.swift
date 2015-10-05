//
//  SelectViewController.swift
//  Panther
//
//  Created by Mark Jackson on 9/29/15.
//  Copyright © 2015 Mark Jackson. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    let noSelectionColor: UIColor = UIColor(red:0.20, green:0.22, blue:0.25, alpha:1.0)
    let selectionColor: UIColor = UIColor(red:0.18, green:0.84, blue:0.51, alpha:1.0)
    
    @IBOutlet weak var letsGoButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var schoolChecked = -1
    let schools: [String] = ["Chapman University"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        
    }
    
    @IBAction func clickDismiss(sender: AnyObject) {
        if(schoolChecked > -1){
            let nvc = self.presentingViewController as! UINavigationController
            let vc = nvc.topViewController as! SpotsViewController
            dismissViewControllerAnimated(true, completion: { () -> Void in
                Spots.sharedInstance.sharedDefaults.setObject(self.schools.get(self.schoolChecked)!, forKey: Constants.SCHOOL_KEY)
                vc.reloadData()
            })
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schools.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == schoolChecked){
            schoolChecked = -1
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
            (tableView.cellForRowAtIndexPath(indexPath) as! ChooseSchoolTableViewCell).check(false)
            letsGoButton.backgroundColor = noSelectionColor
            letsGoButton.titleLabel?.textColor = UIColor(white: 1, alpha: 0.3)
            
        }else{
            schoolChecked = indexPath.row
            (tableView.cellForRowAtIndexPath(indexPath) as! ChooseSchoolTableViewCell).check(true)
            letsGoButton.backgroundColor = selectionColor
            letsGoButton.titleLabel?.textColor = UIColor(white: 1, alpha: 1)
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : ChooseSchoolTableViewCell = tableView.dequeueReusableCellWithIdentifier("ChooseCell", forIndexPath: indexPath) as! ChooseSchoolTableViewCell
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.04)
        cell.checkImageView.userInteractionEnabled = true
        cell.schoolLabel.userInteractionEnabled = true
        cell.schoolLabel.text = schools.get(indexPath.row)
        return cell
    }

    
}


@IBDesignable class ChooseSchoolTableViewCell: UITableViewCell {
    
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    private var checked = false
    
    func check(checked: Bool){
        self.checked = checked
        if(checked){
            checkImageView.image = UIImage(named: "check")
        }else{
            checkImageView.image = UIImage(named: "empty")
        }
    }
    
    override func drawRect(rect: CGRect) {
        UIColor(white: 1, alpha: 0.09).setStroke()
        
        let topPath = UIBezierPath()
        topPath.lineWidth = 1
        topPath.moveToPoint(CGPointMake(0, 1))
        topPath.addLineToPoint(CGPointMake(rect.width, 1))
        topPath.stroke()
        
        let bottomPath = UIBezierPath()
        bottomPath.lineWidth = 1
        bottomPath.moveToPoint(CGPointMake(0, rect.height - 1))
        bottomPath.addLineToPoint(CGPointMake(rect.width, rect.height - 1))
        bottomPath.stroke()
    }
    
}