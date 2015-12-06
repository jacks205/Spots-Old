//
//  TodayCollectionViewCell.swift
//  TodayExtensionTest
//
//  Created by Mark Jackson on 9/27/15.
//  Copyright © 2015 Mark Jackson. All rights reserved.
//

import UIKit

class TodayCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var inflatingView: TodayView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
}

class TodayEmptyCollectionViewCell: UICollectionViewCell {
    
}