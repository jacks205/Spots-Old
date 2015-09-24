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
            cell.totalSpots.text = "\(structure.available)"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! PantherTableViewCell).setCollectionViewDataSourceDelegate(self, withDelegate: self, atIndexPath: indexPath)
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    //MARK: CollectionView Data source methods
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let ratioSmallWidth : CGFloat = 40/273
        let ratioSmallHeight : CGFloat = 40/62
        let newWidth : CGFloat = ratioSmallWidth * collectionView.frame.width
        return CGSize(width: newWidth, height: newWidth / ratioSmallHeight)
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
        cell.circleDataView.circleIndicatorView.setCapacityLevel(CGFloat(level.available), outOfTotalCapacity: CGFloat(level.total))
        cell.circleDataView.titleLabel.text = "Level \(level.number)"
        cell.circleDataView.countLabel.text = "\(level.available)"
        cell.circleDataView.circleIndicatorView.setNeedsDisplay()
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

