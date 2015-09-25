//
//  AddAlertModalViewController.swift
//  Panther
//
//  Created by Mark Jackson on 9/24/15.
//  Copyright © 2015 Mark Jackson. All rights reserved.
//

import UIKit

class ColoredDatePicker: UIDatePicker {
    var changed = false
    override func addSubview(view: UIView) {
        if !changed {
            changed = true
            self.setValue(UIColor.whiteColor(), forKey: "textColor")
        }
        super.addSubview(view)
    }
}

class AddAlertModalViewController: UIViewController {

    @IBOutlet weak var saveBarBtn: UIBarButtonItem!
    @IBOutlet weak var cancelBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var datePicker: ColoredDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let font = UIFont(name: "OpenSans", size: 15) {
            if let smallerFont = UIFont(name: "OpenSans", size: 11){
                self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: smallerFont, NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 0.48)]
            }
            saveBarBtn.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Normal)
            cancelBarBtn.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Normal)
        }
        
//        datePicker.backgroundColor = UIColor.blackColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAlert(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelModal(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
