//
//  ParseClient.swift
//  On the Map
//
//  Created by Mario Preishuber on 31/03/16.
//  Copyright © 2016 Preishuber. All rights reserved.
//

import Foundation

class ParseClient: NetworkUtils {
    
    var userDataList: [UserData] = []
    
    func taskForGETMethod(method: String, parameters: [String:String], completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL:
            self.parseURLFromParameters(parameters, withPathExtension:method))
        request.addValue(ReqeustValues.XParseAppId, forHTTPHeaderField: RequestKeys.XParseAppId)
        request.addValue(ReqeustValues.XParseRestApiKey, forHTTPHeaderField: RequestKeys.XParseRestApiKey)
        
        return self.task(request, completionHandler: completionHandlerForGET)
    }
    
    func taskForPOSTMethod(method: String, jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let request = NSMutableURLRequest(URL: parseURLWithPathExtension(method))
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)

        print(request)
        return self.task(request, completionHandler: completionHandlerForPOST)
    }
    
    func taskForPUTMethod(method: String,  jsonBody: String, completionHandlerForPUT: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: parseURLWithPathExtension(method))
        
        request.HTTPMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        print(request)
        return self.task(request, completionHandler: completionHandlerForPUT)

    }
    
    // create a URL from parameters
    private func parseURLFromParameters(parameters: [String:AnyObject], withPathExtension: String) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = ParseClient.APIConstants.ApiScheme
        components.host = ParseClient.APIConstants.ApiHost
        components.path = ParseClient.APIConstants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    private func parseURLWithPathExtension(withPathExtension: String) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = ParseClient.APIConstants.ApiScheme
        components.host = ParseClient.APIConstants.ApiHost
        components.path = ParseClient.APIConstants.ApiPath + withPathExtension
        components.queryItems = [NSURLQueryItem]()
        
        return components.URL!
    }
    
    
    func userDataToJSONBody() -> String {
        return "{" +
            "\"\(JSONBodyKeys.UniqueKey)\": \"\(AppVariables.userData.getUniqueKey())\"," +
            "\"\(JSONBodyKeys.FirstName)\": \"\(AppVariables.userData.getFirstName())\"," +
            "\"\(JSONBodyKeys.LastName)\" : \"\(AppVariables.userData.getLastName())\"," +
            "\"\(JSONBodyKeys.MapString)\": \"\(AppVariables.userData.getMapString())\"," +
            "\"\(JSONBodyKeys.MediaURL)\" : \"\(AppVariables.userData.getMediaURL())\"," +
            "\"\(JSONBodyKeys.Latitude)\" : \(AppVariables.userData.getLatitude())," +
            "\"\(JSONBodyKeys.Longitude)\": \(AppVariables.userData.getLongitude())" +
        "}"
    }
    
    
    // shared instance
    override class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }

}
