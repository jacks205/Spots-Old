//
//  SelectViewController.swift
//  Panther
//
//  Created by Mark Jackson on 9/29/15.
//  Copyright © 2015 Mark Jackson. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var schoolLabel: UILabel!
    
    let schools: [String] = ["Chapman University"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.dataSource = self
        picker.delegate = self
        
    }

    @IBAction func selectedClick(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject(schools.get(picker.selectedRowInComponent(0)), forKey: Constants.SCHOOL_KEY)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: schools.get(component)!, attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        return attributedString
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        schoolLabel.text = schools.get(component)!
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return schools.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
}
