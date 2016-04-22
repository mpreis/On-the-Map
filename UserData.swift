//
//  ParseStudentLocation.swift
//  On the Map
//
//  Created by Mario Preishuber on 01/04/16.
//  Copyright © 2016 Preishuber. All rights reserved.
//

import Foundation

struct UserData {
 
    let createdAt: String
    let updatedAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    
    init(uniqueKey: String, firstName: String, lastName: String) {
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        
        createdAt = ""
        updatedAt = ""
        latitude = 0.0
        longitude = 0.0
        mapString = ""
        mediaURL = ""
        objectId = ""
    }
    
    init(dictionary: [String:AnyObject]) {
        /*
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSSxxx"
        createdAt = dateFormatter.dateFromString(
            dictionary[ParseClient.JSONBodyKeys.CreatedAt] as! String)!
        updatedAt = dateFormatter.dateFromString(
            dictionary[ParseClient.JSONBodyKeys.UpdatedAt] as! String)!
        */
        
        createdAt = dictionary[ParseClient.JSONBodyKeys.CreatedAt] as! String
        updatedAt = dictionary[ParseClient.JSONBodyKeys.UpdatedAt] as! String
        
        firstName = dictionary[ParseClient.JSONBodyKeys.FirstName] as! String
        lastName = dictionary[ParseClient.JSONBodyKeys.LastName] as! String
        latitude = dictionary[ParseClient.JSONBodyKeys.Latitude] as! Double
        longitude = dictionary[ParseClient.JSONBodyKeys.Longitude] as! Double
        mapString = dictionary[ParseClient.JSONBodyKeys.MapString] as! String
        mediaURL = dictionary[ParseClient.JSONBodyKeys.MediaURL] as! String
        objectId = dictionary[ParseClient.JSONBodyKeys.ObjectId] as! String
        uniqueKey = dictionary[ParseClient.JSONBodyKeys.UniqueKey] as! String
    }
    
    static func studentLocationFromResults(results: [[String:AnyObject]]) -> [UserData] {
        var studentLocations = [UserData]()
        for result in results {
            studentLocations.append(UserData(dictionary: result))
        }
        
        return studentLocations.sort({ $0.lastName < $1.lastName })
    }
}

extension UserData: Equatable {}

func ==(lhs: UserData, rhs: UserData) -> Bool {
    return lhs.uniqueKey == rhs.uniqueKey
}
