//
//  UdacityConstants.swift
//  On the Map
//
//  Created by Mario Preishuber on 29/03/16.
//  Copyright © 2016 Preishuber. All rights reserved.
//

import Foundation

extension UdacityClient {

    struct APIConstants {
        // URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    struct Methods {
        static let Session = "/session"
        static let UserData = "/users"
    }

    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    struct JSONResponseKeys {
        // Auth
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
        static let Session = "session"
        static let Id = "id"
        static let Expiration = "expiration"
        // User Data
    }
}