//
//  ParseStudentLocation.swift
//  On the Map
//
//  Created by Mario Preishuber on 01/04/16.
//  Copyright © 2016 Preishuber. All rights reserved.
//

import Foundation

struct UserData {
 
    private let uniqueKey: String
    private let firstName: String
    private let lastName: String
    
    private var createdAt: String?
    private var updatedAt: String?
    private var latitude: Double?
    private var longitude: Double?
    private var mapString: String?
    private var mediaURL: String?
    private var objectId: String?
    
    init(uniqueKey: String, firstName: String, lastName: String) {
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        
        createdAt = nil; updatedAt = nil
        latitude = nil; longitude = nil
        mapString = nil; mediaURL = nil
        objectId = nil
    }
    
    init(dictionary: [String:AnyObject]) {
        uniqueKey = dictionary[ParseClient.JSONBodyKeys.UniqueKey] as! String
        firstName = dictionary[ParseClient.JSONBodyKeys.FirstName] as! String
        lastName = dictionary[ParseClient.JSONBodyKeys.LastName] as! String
        
        objectId = dictionary[ParseClient.JSONBodyKeys.ObjectId] as? String
        createdAt = dictionary[ParseClient.JSONBodyKeys.CreatedAt] as? String
        updatedAt = dictionary[ParseClient.JSONBodyKeys.UpdatedAt] as? String
        
        latitude = dictionary[ParseClient.JSONBodyKeys.Latitude] as? Double
        longitude = dictionary[ParseClient.JSONBodyKeys.Longitude] as? Double
        
        mapString = dictionary[ParseClient.JSONBodyKeys.MapString] as? String
        mediaURL = dictionary[ParseClient.JSONBodyKeys.MediaURL] as? String
    }
    
    func exsistsPin() -> Bool {
        return objectId != nil
    }
    
    mutating func prepareToUpdatePin(mediaURL: String, mapString: String, latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        
    }
    
    mutating func setUpdatedAt(updatedAt: String) { self.updatedAt = updatedAt }
    mutating func setCreatedAt(createdAt: String) { self.createdAt = createdAt }
    mutating func setObjectId(objectId: String) { self.objectId = objectId }
    
    func getObjectId() -> String { return self.objectId! }
    func getUniqueKey() -> String { return self.uniqueKey }
    func getFirstName() -> String { return self.firstName }
    func getLastName() -> String { return self.lastName }
    func getMapString() -> String { return self.mapString! }
    func getMediaURL() -> String { return self.mediaURL! }
    func getLatitude() -> Double { return self.latitude! }
    func getLongitude() -> Double { return self.longitude! }
    
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
