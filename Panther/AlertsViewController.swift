//
//  AlertsViewController.swift
//  Panther
//
//  Created by Mark Jackson on 9/23/15.
//  Copyright © 2015 Mark Jackson. All rights reserved.
//

import UIKit
import BGTableViewRowActionWithImage

class Alert {
    let day : String
    let time : NSDate
    
    var enabled : Bool
    
    init(day: String, time: NSDate){
        self.day = day
        self.time = time
        self.enabled = true
    }
    
    func getTimeString() -> String{
        return Alert.getTimeString(time)
    }
    
    static func getTimeString(date: NSDate) -> String{
        let dateFormat : NSDateFormatter = NSDateFormatter()
        dateFormat.dateFormat = "h:mma"
        return dateFormat.stringFromDate(date)
    }
    
}

protocol AddAlertProtocol{
    func addAlert(day : String, forTime time: NSDate)
}

class AlertsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddAlertProtocol{
    
    @IBOutlet weak var emptyAlertsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var alerts : [Alert] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

//        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
//        let localNotification: UILocalNotification = UILocalNotification()
//        localNotification.alertAction = "Testing notifications on iOS8"
//        localNotification.alertBody = "It works!"
//        localNotification.fireDate = NSDate(timeIntervalSinceNow: 60)
//        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
        
        
        checkIfTableViewIsEmpty()
        
    }
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addNotification() {
        performSegueWithIdentifier("addNotification", sender: self)
        
    }
    
    func addAlert(day : String, forTime time: NSDate){
        let newAlert = Alert(day: day, time: time)
        alerts.append(newAlert)
        checkIfTableViewIsEmpty()
    }
    
    func checkIfTableViewIsEmpty(){
        if(alerts.count > 0){
            //Show table
            tableView.hidden = false
            emptyAlertsView.hidden = true
            
            tableView.delegate = self
            tableView.dataSource = self
            tableView.allowsSelection = false
            tableView.allowsMultipleSelectionDuringEditing = false
            tableView.reloadData()
        }else{
            //Show empty view
            tableView.hidden = true
            emptyAlertsView.hidden = false
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "addNotification"){
            let nav : UINavigationController = segue.destinationViewController as! UINavigationController
            let amc : AddAlertModalViewController =  nav.topViewController as! AddAlertModalViewController
            amc.delegate = self
        }
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return alerts.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlertCell", forIndexPath: indexPath) as! AlertTableViewCell
        // Configure the cell...
        if let alert : Alert = alerts.get(indexPath.row){
            cell.setAlert(alert)
        }

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    //http://stackoverflow.com/a/26079874/4684652
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteBtn = BGTableViewRowActionWithImage.rowActionWithStyle(.Normal, title: "    ", backgroundColor: tableView.backgroundColor, image: UIImage(named: "delete.png"), forCellHeight: 95) { (_, _) -> Void in
            self.alerts.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.checkIfTableViewIsEmpty()
        }
        return [deleteBtn]
    }
    

}
