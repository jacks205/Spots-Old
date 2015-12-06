//
//  ViewController.swift
//  Panther
//
//  Created by Mark Jackson on 9/21/15.
//  Copyright © 2015 Mark Jackson. All rights reserved.
//

import UIKit

class SpotsViewController: UITableViewController {
    
    //MARK: - Fields
    /**
        Array of parking structures, will fill tableview.
    */
    var parkingStructures : [ParkingStructure] = []
    //MARK: Rate Me Fields
    /**
        Minimum sessions before rate me appears
    */
    var minSessions = Constants.Review.MIN_SESSIONS
    /**
        Number of sessions to add to minSessions if they choose "Maybe Later"
    */
    var tryAgainSessions = Constants.Review.TRY_AGAIN_SESSIONS
    
    //MARK: - ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Remove navigation controller shadow (black line)
        navigationController?.navigationBar.shadowImage = UIImage()
        //Set shadow image as an empty image
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        //Allow pull to go back in nvc
        navigationController?.interactivePopGestureRecognizer?.enabled = true
        
        //Set font of navigation tab bar
        if let smallerFont = UIFont(name: "OpenSans", size: 11){
            navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: smallerFont, NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 0.48)]
        }
        //Set the navigation bar color
        navigationController!.navigationBar.barTintColor = Constants.Colors.DARK_BLUE_COLOR
        
        //Pull to refresh for table view
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "reloadData:", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl?.attributedTitle = NSAttributedString(string: "Updated ",
            attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 11)!,
                NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 0.48)])
        
        //Check if user has selected a university already if so, load university data, otherwise show modal to select university
        if let _ = Spots.sharedInstance.sharedDefaults.objectForKey(Constants.SCHOOL_KEY){
            rateMe()
        }else{
            //choose school modal
            performSegueWithIdentifier("SelectSchool", sender: self)
        }
        
        //Refresh parking data
        reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Rate Me Methods
    /**
        Logic to launch alert if they have reached minSessions
        - Returns: Void
    */
    func rateMe() {
        let neverRate = NSUserDefaults.standardUserDefaults().boolForKey("neverRate")
        var numLaunches = NSUserDefaults.standardUserDefaults().integerForKey("numLaunches") + 1
        
        if (!neverRate && (numLaunches == minSessions || numLaunches >= (minSessions + tryAgainSessions + 1)))
        {
            showRateMe()
            numLaunches = minSessions + 1
        }
        NSUserDefaults.standardUserDefaults().setInteger(numLaunches, forKey: "numLaunches")
    }
    
    /**
        Show alert to rate app
        - Returns: Void
    */
    func showRateMe() {
        let alert = UIAlertController(title: "Rate Us", message: "Thanks for using Spots. Please go rate us in the App Store!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Rate Spots", style: UIAlertActionStyle.Default, handler: { alertAction in
            UIApplication.sharedApplication().openURL(NSURL(string : Constants.APP_STORE_URL)!)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "neverRate")
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No Thanks", style: UIAlertActionStyle.Default, handler: { alertAction in
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "neverRate")
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Maybe Later", style: UIAlertActionStyle.Default, handler: { alertAction in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: - Reload data methods
    
    /**
        Target for the refresh controller
    */
    func reloadData(sender : AnyObject){
        reloadData()
    }
    
    /**
        Make network call to get university parking data
        
        Invokes Spots.fetchParkingData, and updates self.parkingStructures. Once complete, it refreshes the table view.
        - Returns: Void
    */
    func reloadData(){
        //Get array of parking structures and last time it was updated
        Spots.sharedInstance.fetchParkingData { (lastUpdated, data, error) -> Void in
            if let _ = error{
                //alert
            }else{
                self.parkingStructures = data!
                if let validDate = lastUpdated{
                    self.refreshControl?.attributedTitle = NSAttributedString(string: "Updated " + timeAgoSinceDate(validDate, numericDates: true),
                        attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 11)!,
                            NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 0.48)])
                }
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        }
    }
    
    //MARK: - Table view data source/delegate methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkingStructures.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let structure : ParkingStructure = parkingStructures[safe: indexPath.row]{
            switch (structure.levels.count){
            case 2:
                let cell = tableView.dequeueReusableCellWithIdentifier("Cell2") as! SpotsTableViewCell
                cell.title.text = structure.name.capitalizedString
                cell.totalSpots.text = "\(structure.available) spots available"
                cell.circleView.circlePieView.setSegmentValues(structure.levels)
                let percent = 100 - (Double(structure.available) / Double(structure.total)) * 100
                cell.circleView.percentageLabel.text = percent.format(".0") + "%"
                cell.level1Available.text = "\(structure.levels[0].available) spots"
                cell.level2Available.text = "\(structure.levels[1].available) spots"
                return cell
            case 5:
                let cell = tableView.dequeueReusableCellWithIdentifier("Cell5") as! SpotsTableViewCell
                cell.title.text = structure.name.capitalizedString
                cell.totalSpots.text = "\(structure.available) spots available"
                cell.circleView.circlePieView.setSegmentValues(structure.levels)
                let percent = 100 - (Double(structure.available) / Double(structure.total)) * 100
                cell.circleView.percentageLabel.text = percent.format(".0") + "%"
                cell.level1Available.text = "\(structure.levels[0].available) spots"
                cell.level2Available.text = "\(structure.levels[1].available) spots"
                cell.level3Available.text = "\(structure.levels[2].available) spots"
                cell.level4Available.text = "\(structure.levels[3].available) spots"
                cell.level5Available.text = "\(structure.levels[4].available) spots"
                return cell
            default:
                break
            }
            
            
            
        }
        
        return tableView.dequeueReusableCellWithIdentifier("Cell2") as! SpotsTableViewCell
    }
    

}

extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}
