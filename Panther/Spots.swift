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
    
    /**
        Spots.sharedDefaults should be used to keep data available in the app and in the extension. Can't access NSUserDefaults.sharedDefaults on the extension or vise versaS.
    */
    let sharedDefaults: NSUserDefaults
    
    private init(){
        sharedDefaults = NSUserDefaults(suiteName: Constants.SUITE_NAME)!
    }
    
    /**
        Fetched parking data from API and calls completion callback once successful or failure occurs.
        - Parameter completion: Callback that is called once data is retrieved or network call fails.
        - Returns: (In callback): when the data was last updated, array of parking structure data, and an error variable
    */
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
    
    /**
        Parses JSON data from API into ParkingStructure and ParkingLevel struct types.
        - Parameter data: JSON data from API
        - Parameter completion: Callback once data is serialized into objects.
    */
    static func parseParkingData(data: JSON?, completion: (lastUpdated: NSDate?, result: [ParkingStructure], error: NSError?) -> ()){
        if let json = data {
            //implement when data is altered
            var parkingStructures: [ParkingStructure] = []
            for (_,subJson):(String, JSON) in json["structures"] {
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

/**
    Takes a past NSDate and creates a string representation of it.
    
    ex: "1 week ago"

    ex: "Last week"

    - Parameter date: Past date you wish to create a string representation for.
    - Parameter numericDates: if true, ex: "1 week ago", else ex: "Last week"
    - Returns: String that represents your date.
*/
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

//MARK: - Array Extension

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
