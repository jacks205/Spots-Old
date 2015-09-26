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
        
        if let smallerFont = UIFont(name: "OpenSans", size: 11){
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: smallerFont, NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 0.48)]
        }
        navigationController!.navigationBar.barTintColor = Constants.Colors.DARK_BLUE_COLOR
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "reloadData:", forControlEvents: UIControlEvents.ValueChanged)
        
        reloadData(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadData(sender : AnyObject){
        Panther.sharedInstance.fetchParkingData { (data, error) -> Void in
            if let err = error{
                //alert
            }else{
                self.parkingStructures = data!
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
            cell.title.text = structure.name
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
        if let structure = parkingStructures.get((collectionView as! PantherIndexedCollectionView).indexPath.row){
            return structure.levels.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : CircleDataCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! CircleDataCollectionViewCell
        let level : ParkingLevel = parkingStructures.get((collectionView as! PantherIndexedCollectionView).indexPath.row)!.levels.get(indexPath.row)!
        cell.inflatingCircleDataView.inflatingCircleIndicatorView.setCapacityLevel(CGFloat(level.available), outOfTotalCapacity: CGFloat(level.total))
        cell.inflatingCircleDataView.titleLabel.text = "Level \(level.number)"
        cell.inflatingCircleDataView.countLabel.text = "\(level.available)"
        cell.inflatingCircleDataView.inflatingCircleIndicatorView.setNeedsDisplay()
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

