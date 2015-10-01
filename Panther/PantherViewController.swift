//
//  ViewController.swift
//  Panther
//
//  Created by Mark Jackson on 9/21/15.
//  Copyright © 2015 Mark Jackson. All rights reserved.
//

import UIKit

class PantherViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var parkingStructures : [ParkingStructure] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.interactivePopGestureRecognizer?.enabled = true
        
        if let smallerFont = UIFont(name: "OpenSans", size: 11){
            navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: smallerFont, NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 0.48)]
        }
        navigationController!.navigationBar.barTintColor = Constants.Colors.DARK_BLUE_COLOR
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "reloadData:", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl?.attributedTitle = NSAttributedString(string: "Updated ",
            attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 11)!,
                NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 0.48)])
        print(NSUserDefaults.standardUserDefaults().objectForKey(Constants.DEVICE_TOKEN_KEY))
        
//        if let _ = NSUserDefaults.standardUserDefaults().objectForKey(Constants.SCHOOL_KEY){
//
//        }else{
//            performSegueWithIdentifier("SelectSchool", sender: self)
//        }
        
        
        reloadData(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadData(sender : AnyObject){
        Panther.sharedInstance.fetchParkingData { (lastUpdated, data, error) -> Void in
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
    
    //MARK: Table view data source/delegate methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : PantherTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PantherTableViewCell
        
        if let structure : ParkingStructure = parkingStructures.get(indexPath.row){
            cell.title.text = structure.name.capitalizedString
            cell.totalSpots.text = "\(structure.available) spots available"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! PantherTableViewCell).setCollectionViewDataSourceDelegate(self, withDelegate: self, atIndexPath: indexPath)
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    //MARK: CollectionView Data source methods
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let ratioSmallWidth : CGFloat = 50/304
//        let ratioSmallHeight : CGFloat = 50/84
//        let newWidth : CGFloat = ratioSmallWidth * collectionView.frame.width
//        print(collectionView.frame)
//        return CGSize(width: newWidth, height: newWidth / ratioSmallHeight)
//    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        let cvWidth = collectionView.bounds.width / 5
        return cvWidth - 50
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if let structure = parkingStructures.get((collectionView as! PantherIndexedCollectionView).indexPath.row){
//            return structure.levels.count
//        }
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath)
        let pantherCollectionViewCell : PantherIndexedCollectionView = collectionView as! PantherIndexedCollectionView
        if let structure : ParkingStructure = parkingStructures.get((pantherCollectionViewCell).indexPath.row){
            if let level : ParkingLevel = structure.levels.get(indexPath.row){
                let cdCell : CircleDataCollectionViewCell = cell as! CircleDataCollectionViewCell
                cdCell.inflatingCircleDataView.inflatingCircleIndicatorView.setCapacityLevel(CGFloat(level.available), outOfTotalCapacity: CGFloat(level.total))
                cdCell.inflatingCircleDataView.titleLabel.text = "Level \(level.number)"
                cdCell.inflatingCircleDataView.countLabel.text = "\(level.available)"
                cdCell.inflatingCircleDataView.inflatingCircleIndicatorView.animateCircle(Double(pantherCollectionViewCell.indexPath.row) * 0.35 + Double(indexPath.row) * 0.15)
//                cdCell.inflatingCircleDataView.inflatingCircleIndicatorView.setNeedsDisplay()
            }else{
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("EmptyCell", forIndexPath: indexPath)
            }
        }
        return cell
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

