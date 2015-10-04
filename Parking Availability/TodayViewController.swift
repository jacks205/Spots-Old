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
    
    @IBOutlet weak var noSchoolSelectedView: UIView!
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var parkingStructures : [ParkingStructure] = []
    var latestUpdate : NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
//        if let _ = NSUserDefaults.standardUserDefaults().objectForKey(Constants.SCHOOL_KEY){
//            noSchoolSelectedView.hidden = true
//            collectionView.hidden = false
//            preferredContentSize = CGSizeMake(0, 173)
//            collectionView.delegate = self
//            collectionView.dataSource = self
//            reloadData(self)
//        }else{
//            preferredContentSize = CGSizeMake(0, 60)
//            noSchoolSelectedView.hidden = false
//            collectionView.hidden = true
//        }
//        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = Spots.sharedInstance.sharedDefaults.objectForKey(Constants.SCHOOL_KEY){
            noSchoolSelectedView.hidden = true
            collectionView.hidden = false
            preferredContentSize = CGSizeMake(0, 173)
            collectionView.delegate = self
            collectionView.dataSource = self
            reloadData(self)
        }else{
            preferredContentSize = CGSizeMake(0, 60)
            noSchoolSelectedView.hidden = false
            collectionView.hidden = true
        }
        
        if let timeUpdated = latestUpdate {
            updatedLabel.text = "Updated " + timeAgoSinceDate(timeUpdated, numericDates: true)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectSchoolClick(sender: AnyObject) {
        extensionContext!.openURL(NSURL(string: "AppUrlType://home")!, completionHandler: nil)
    }
    
    func reloadData(sender : AnyObject){
        Spots.sharedInstance.fetchParkingData { (lastUpdated, data, error) -> Void in
            if let _ = error{
                //alert
            }else{
//                print(lastUpdated)
                self.parkingStructures = data!
                print(lastUpdated)
                if let validDate = lastUpdated{
                    self.latestUpdate = validDate
                    self.updatedLabel.text = "Updated " + timeAgoSinceDate(validDate, numericDates: true)
                }
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
        
        if let structure: ParkingStructure = parkingStructures.get(indexPath.row){
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

extension Array {
    
    // Safely lookup an index that might be out of bounds,
    // returning nil if it does not exist
    func get(index: Int) -> Element? {
        if 0 <= index && index < count {
            return self[index]
        } else {
            return nil
        }
    }
}
