//
//  Panther.swift
//  Panther
//
//  Created by Mark Jackson on 9/21/15.
//  Copyright © 2015 Mark Jackson. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Spots {
    
    static let sharedInstance = Spots()
    
    let sharedDefaults: NSUserDefaults
    
    init(){
        sharedDefaults = NSUserDefaults(suiteName: Constants.SUITE_NAME)!
    }
    
    func fetchParkingData(completion: (NSDate?, [ParkingStructure]?, ErrorType?) -> Void){
        let ip : String = Constants.IP_ADDRESS
        //New iOS 9 http protection: http://stackoverflow.com/questions/31254725/transport-security-has-blocked-a-cleartext-http
        Alamofire.request(.GET, ip)
            .responseJSON { (_, _, result) -> Void in
                if let error = result.error{
                    completion(nil, nil, error)
                    return
                }
                let json : JSON = JSON(result.value!)
                SpotParser.parseParkingData(json, completion: { (lastUpdated, structures, error) -> () in
                    completion(lastUpdated, structures, error)
                })
        }
    }
    
}

class SpotParser {
    
    init(){
        
    }
    
    static func parseParkingData(data: JSON?, completion: (lastUpdated: NSDate?, result: [ParkingStructure], error: NSError?) -> ()){
        if let json = data {
            //implement when data is altered
            var parkingStructures: [ParkingStructure] = []
            for (_,subJson):(String, JSON) in json["structures"] {
                //Do something you want
                if let name: String = subJson["name"].string,
                let available = subJson["available"].int,
                let total = subJson["total"].int {
                    var parkingLevels: [ParkingLevel] = []
                    for(_, levelsJson):(String, JSON) in subJson["levels"] {
                        if let total = levelsJson["total"].int,
                        let name = levelsJson["name"].string,
                        let available = levelsJson["available"].int {
                            parkingLevels.append(ParkingLevel(number: name, available: available, total: total))
                        }
                    }
                    parkingStructures.append(ParkingStructure(name: name, available: available, total: total, totalLevels: parkingLevels.count, levels: parkingLevels))
                    
                }
            }
            //2015-09-28T06:30:00.223Z
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
//            dateFormatter.formatterBehavior = .BehaviorDefault
            if let dateString = json["lastUpdatedISO"].string {
                if let updated = dateFormatter.dateFromString(dateString) {
                    completion(lastUpdated: updated, result: parkingStructures, error: nil)
                    return;
                }
            }
                completion(lastUpdated: nil, result: parkingStructures, error: nil)
            
        }
//        let lastingerLevels : [ParkingLevel] = [ParkingLevel(number: 1, available: 9, total: 401), ParkingLevel(number: 2, available: 6, total: 470)]
//        let barreraLevels : [ParkingLevel] = [ParkingLevel(number: 1, available: 5, total: 86), ParkingLevel(number: 2, available: 8, total: 146), ParkingLevel(number: 3, available: 0, total: 150), ParkingLevel(number: 4, available: 5, total: 150), ParkingLevel(number: 5, available: 12, total: 163)]
//        let westCampusLevels : [ParkingLevel] = [ParkingLevel(number: 1, available: 6, total: 77), ParkingLevel(number: 2, available: 20, total: 77), ParkingLevel(number: 3, available: 15, total: 69), ParkingLevel(number: 4, available: 25, total: 74), ParkingLevel(number: 5, available: 30, total: 64)]
//        
//        completion( result: [
//            ParkingStructure(name: "Lastinger", available: 18, total: 871, totalLevels: 2, levels: lastingerLevels),
//            ParkingStructure(name: "Barrera", available: 13, total: 695, totalLevels: 5, levels: barreraLevels),
//            ParkingStructure(name: "West Campus", available: 58, total: 360, totalLevels: 5, levels: westCampusLevels)
//        ], error: nil)
        
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
    let number: String
    let available, total : Int
    
    init(number : String, available : Int, total : Int){
        self.number = number
        self.available = available
        self.total = total
    }
    
    
}

func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
    let calendar = NSCalendar.currentCalendar()
    let now = NSDate()
    let earliest = now.earlierDate(date)
    let latest = (earliest == now) ? date : now
    let components:NSDateComponents = calendar.components([NSCalendarUnit.Minute , NSCalendarUnit.Hour , NSCalendarUnit.Day , NSCalendarUnit.WeekOfYear , NSCalendarUnit.Month , NSCalendarUnit.Year , NSCalendarUnit.Second], fromDate: earliest, toDate: latest, options: NSCalendarOptions())
    
    if (components.year >= 2) {
        return "\(components.year) years ago"
    } else if (components.year >= 1){
        if (numericDates){
            return "1 year ago"
        } else {
            return "Last year"
        }
    } else if (components.month >= 2) {
        return "\(components.month) months ago"
    } else if (components.month >= 1){
        if (numericDates){
            return "1 month ago"
        } else {
            return "Last month"
        }
    } else if (components.weekOfYear >= 2) {
        return "\(components.weekOfYear) weeks ago"
    } else if (components.weekOfYear >= 1){
        if (numericDates){
            return "1 week ago"
        } else {
            return "Last week"
        }
    } else if (components.day >= 2) {
        return "\(components.day) days ago"
    } else if (components.day >= 1){
        if (numericDates){
            return "1 day ago"
        } else {
            return "Yesterday"
        }
    } else if (components.hour >= 2) {
        return "\(components.hour) hours ago"
    } else if (components.hour >= 1){
        if (numericDates){
            return "1 hour ago"
        } else {
            return "An hour ago"
        }
    } else if (components.minute >= 2) {
        return "\(components.minute) minutes ago"
    } else if (components.minute >= 1){
        if (numericDates){
            return "1 minute ago"
        } else {
            return "A minute ago"
        }
    } else if (components.second >= 3) {
        return "\(components.second) seconds ago"
    } else {
        return "Just now"
    }
    
}