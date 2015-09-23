//
//  ViewController.swift
//  Panther
//
//  Created by Mark Jackson on 9/21/15.
//  Copyright © 2015 Mark Jackson. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var parkingStructures : [ParkingStructure] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationController!.navigationBar.barTintColor = Constants.Colors.NAVIGATION_BAR_COLOR
        
        Panther.sharedInstance.fetchParkingData { (data, error) -> Void in
            if let err = error{
                //alert
            }else{
                self.parkingStructures = data!
                self.tableView.reloadData()
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Table view data source/delegate methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : PantherTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PantherTableViewCell
        
        if let structure : ParkingStructure = parkingStructures.get(indexPath.row){
            cell.title.text = structure.name
            cell.totalSpots.text = "\(structure.available)"
        }
        
        print("!\(indexPath.row)!")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! PantherTableViewCell).setCollectionViewDataSourceDelegate(self, withDelegate: self, atIndexPath: indexPath)
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    //MARK: CollectionView Data source methods
    
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

