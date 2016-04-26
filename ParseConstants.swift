//
//  ParseConstants.swift
//  On the Map
//
//  Created by Mario Preishuber on 31/03/16.
//  Copyright © 2016 Preishuber. All rights reserved.
//

import Foundation

extension ParseClient {
    
    struct APIConstants {
        static let ApiScheme = "https"
        static let ApiHost = "api.parse.com"
        static let ApiPath = "/1"
    }
    
    struct Methods {
        static let StudentLocation = "/classes/StudentLocation"
    }
    
    struct Parameters {
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "Order"
        static let OrderDesc = "-"
        static let OrderAsc = ""
        static let Where = "where"
    }
    
    struct JSONBodyKeys {
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let Results = "results"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    struct RequestKeys {
        static let XParseAppId = "X-Parse-Application-Id"
        static let XParseRestApiKey = "X-Parse-REST-API-Key"
    }
    
    struct ReqeustValues {
        static let XParseAppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let XParseRestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
}