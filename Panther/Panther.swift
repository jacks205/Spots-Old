//
//  Panther.swift
//  Panther
//
//  Created by Mark Jackson on 9/21/15.
//  Copyright © 2015 Mark Jackson. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Panther {
    
    static let sharedInstance = Panther()
    
    init(){
        
    }
    
    func fetchParkingData(completion: ([ParkingStructure]?, NSError?) -> Void){
        Alamofire.request(.GET, Constants.IP_ADDRESS)
            .responseJSON { (_, _, result) -> Void in
                let json : JSON = JSON(result.value!)
                PantherParser.parseParkingData(json, completion: { (result, error) -> () in
                    completion(result, error)
                })
        }
    }
    
}

class PantherParser {
    
    init(){
        
    }
    
    static func parseParkingData(data: JSON?, completion: (result: [ParkingStructure], error: NSError) -> ()){
        
    }
    
    
}

class ParkingStructure {
    
}