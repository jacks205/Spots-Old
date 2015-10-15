//
//  ViewController.swift
//  Panther
//
//  Created by Mark Jackson on 9/21/15.
//  Copyright © 2015 Mark Jackson. All rights reserved.
//

import UIKit

class SpotsViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //Array of parking structures, will fill tableview
    var parkingStructures : [ParkingStructure] = []

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
    
    //MARK: - Reload data methods
    
    //Target for the refresh controller
    func reloadData(sender : AnyObject){
        reloadData()
    }
    
    //Make network call to get university parking data
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
        let cell : SpotsTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! SpotsTableViewCell
        
        if let structure : ParkingStructure = parkingStructures[safe: indexPath.row]{
            cell.title.text = structure.name.capitalizedString
            cell.totalSpots.text = "\(structure.available) spots available"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! SpotsTableViewCell).setCollectionViewDataSourceDelegate(self, withDelegate: self, atIndexPath: indexPath)
        
    }
    
    //MARK: - CollectionView Data source methods
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        let cvWidth = collectionView.bounds.width / 5
        return cvWidth - 50
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath)
        let pantherCollectionViewCell : SpotsIndexedCollectionView = collectionView as! SpotsIndexedCollectionView
        if let structure : ParkingStructure = parkingStructures[safe: (pantherCollectionViewCell).indexPath.row]{
            if let level : ParkingLevel = structure.levels[safe: indexPath.row]{
                let cdCell : CircleDataCollectionViewCell = cell as! CircleDataCollectionViewCell
                cdCell.inflatingCircleDataView.inflatingCircleIndicatorView.setCapacityLevel(CGFloat(level.available), outOfTotalCapacity: CGFloat(level.total))
                cdCell.inflatingCircleDataView.titleLabel.text = "Level \(level.number)"
                cdCell.inflatingCircleDataView.countLabel.text = "\(level.available)"
                cdCell.inflatingCircleDataView.inflatingCircleIndicatorView.animateCircle(Double(pantherCollectionViewCell.indexPath.row) * 0.35 + Double(indexPath.row) * 0.15)
            }else{
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("EmptyCell", forIndexPath: indexPath)
            }
        }
        return cell
    }
    


}


//MARK - Array Extension

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

