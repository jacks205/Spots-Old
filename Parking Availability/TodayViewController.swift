//
//  TodayViewController.swift
//  Today
//
//  Created by Mark Jackson on 9/27/15.
//  Copyright © 2015 Mark Jackson. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    /**
        View shown when a school hasn't been selected in app yet.
    
        The view contains a button to take user to the app.
    */
    @IBOutlet weak var noSchoolSelectedView: UIView!
    /**
        UILabel thats shows how long ago the data has been updated on the server.
    */
    @IBOutlet weak var updatedLabel: UILabel!
    /**
        UICollectionView of the parking data cells.
    */
    @IBOutlet weak var collectionView: UICollectionView!
    
    /**
        Array of parking structures, will fill collection view.
    */
    var parkingStructures : [ParkingStructure] = []
    /**
        Date of last update.
    */
    var latestUpdate : NSDate?
    
    /**
        Width/Height of the content size.
    
        The shortest height we deal with is 60, so if a school isn't selected, then we have the correct height. If a school is selected, the view will expand to 173, and fill view.
    */
    var preferredLength = CGSizeMake(0, 60)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = Spots.sharedInstance.sharedDefaults.objectForKey(Constants.SCHOOL_KEY){
            //School is chosen
            //...
            //Hide: noSchoolSelectedView
            //Show: collectionView, updateLabel
            noSchoolSelectedView.hidden = true
            collectionView.hidden = false
            updatedLabel.hidden = false
            
            //Set preferred length to 173 (largest height we want)
            preferredLength = CGSizeMake(0, 173)
            
            //Set collectionView delegate and datasource
            collectionView.delegate = self
            collectionView.dataSource = self
            
            //Refresh collection view data
            reloadData(self)
        }else{
            //School is not chosen
            //...
            //Hide: collectionView, updateLabel
            //Show: noSchoolSelectedView
            noSchoolSelectedView.hidden = false
            updatedLabel.hidden = true
            collectionView.hidden = true
            
            //Set preferred length to 60 (smallest height we want)
            preferredLength = CGSizeMake(0, 60)
        }
        
        //Update time label to a "Updated % ago"
        if let timeUpdated = latestUpdate {
            updatedLabel.text = "Updated " + timeAgoSinceDate(timeUpdated, numericDates: true)
        }
        
        //Set extension content size
        preferredContentSize = preferredLength
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        preferredContentSize = preferredLength
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectSchoolClick(sender: AnyObject) {
        //Open app to home screen
        extensionContext!.openURL(NSURL(string: "AppUrlType://home")!, completionHandler: nil)
    }
    
    /**
        Make network call to get university parking data
        
        Invokes Spots.fetchParkingData, and updates self.parkingStructures. Once complete, it refreshes the collection view.
        - Returns: Void
    */
    func reloadData(sender : AnyObject){
        Spots.sharedInstance.fetchParkingData { (lastUpdated, data, error) -> Void in
            if let _ = error{
                //alert
            }else{
                //Check if data is non nil
                guard let data = data else { return }
                
                //Update the parkingStructures data
                self.parkingStructures = data
                
                //Update label
                if let validDate = lastUpdated{
                    self.latestUpdate = validDate
                    self.updatedLabel.text = "Updated " + timeAgoSinceDate(validDate, numericDates: true)
                }
                //Reload collection view cells
                self.collectionView.reloadData()
            }
        }
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        //Change inset based on screen size
        //Must line up to the first letter of the title of extension
        if(view.bounds.width > 320){
            return UIEdgeInsetsMake(0, 45, 0, 0)
        }
        return UIEdgeInsetsMake(0, 20, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell
        
        if let structure: ParkingStructure = parkingStructures[safe: indexPath.row]{
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! TodayCollectionViewCell
            let tc : TodayCollectionViewCell = cell as! TodayCollectionViewCell
            tc.titleLabel.text = structure.name.capitalizedString
            tc.amountLabel.text = "\(structure.available) spots"
            tc.inflatingView.setCapacityLevel(CGFloat(structure.available), outOfTotalCapacity: CGFloat(structure.total))
        }else{
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("EmptyCell", forIndexPath: indexPath) as! TodayEmptyCollectionViewCell
        }
        //        cell.titleLabel.text = "Test"
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = parkingStructures.count
        return (count % 2) == 1 ? count + 1 : count
    }
    
}

