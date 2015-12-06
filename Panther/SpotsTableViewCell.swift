//
//  PantherTableViewCell.swift
//  Panther
//
//  Created by Mark Jackson on 9/21/15.
//  Copyright © 2015 Mark Jackson. All rights reserved.
//

import UIKit

class SpotsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var level1Available: UILabel!
    @IBOutlet weak var level2Available: UILabel!
    @IBOutlet weak var level3Available: UILabel!
    @IBOutlet weak var level4Available: UILabel!
    @IBOutlet weak var level5Available: UILabel!
    @IBOutlet weak var circleView: CirclePieIndicatorView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var totalSpots: UILabel!
    
    // #pragma mark UICollectionViewDataSource
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.setNeedsDisplay()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    


}
