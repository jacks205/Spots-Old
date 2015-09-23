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
    
    func fetchParkingData(completion: ([ParkingStructure]?, ErrorType?) -> Void){
        let ip : String = Constants.IP_ADDRESS
        //New iOS 9 http protection: http://stackoverflow.com/questions/31254725/transport-security-has-blocked-a-cleartext-http
        Alamofire.request(.GET, ip)
            .responseJSON { (_, _, result) -> Void in
                if let error = result.error{
                    completion(nil, error)
                    return
                }
                let json : JSON = JSON(result.value!)
                PantherParser.parseParkingData(json, completion: { (structures, error) -> () in
                    completion(structures, nil)
                })
        }
    }
    
}

class PantherParser {
    
    init(){
        
    }
    
    static func parseParkingData(data: JSON?, completion: (result: [ParkingStructure], error: NSError?) -> ()){
        if let json = data {
            //implement when data is altered
        }
        let lastingerLevels : [ParkingLevel] = [ParkingLevel(number: 1, available: 9, total: 401), ParkingLevel(number: 2, available: 6, total: 470)]
        let barreraLevels : [ParkingLevel] = [ParkingLevel(number: 1, available: 5, total: 86), ParkingLevel(number: 2, available: 8, total: 146), ParkingLevel(number: 3, available: 0, total: 150), ParkingLevel(number: 4, available: 5, total: 150), ParkingLevel(number: 5, available: 12, total: 163)]
        let westCampusLevels : [ParkingLevel] = [ParkingLevel(number: 1, available: 6, total: 77), ParkingLevel(number: 2, available: 20, total: 77), ParkingLevel(number: 3, available: 15, total: 69), ParkingLevel(number: 4, available: 25, total: 74), ParkingLevel(number: 5, available: 30, total: 64)]
        
        completion( result: [
            ParkingStructure(name: "Lastinger", available: 18, total: 871, totalLevels: 2, levels: lastingerLevels),
            ParkingStructure(name: "Barrera", available: 13, total: 695, totalLevels: 5, levels: barreraLevels),
            ParkingStructure(name: "West Campus", available: 58, total: 360, totalLevels: 5, levels: westCampusLevels)
        ], error: nil)
        
    }
    
    
}

struct ParkingStructure {
    
    let name : String
    let available, total, totalLevels : Int
    let levels : [ParkingLevel]
    
    init(name : String, available : Int, total : Int, totalLevels : Int, levels : [ParkingLevel]){
        self.name = name
        self.available = available
        self.total = total
        self.totalLevels = totalLevels
        self.levels = levels
    }
   
}

struct ParkingLevel {
    let number, available, total : Int
    
    init(number : Int, available : Int, total : Int){
        self.number = number
        self.available = available
        self.total = total
    }
    
    
}