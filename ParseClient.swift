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
    
    func taskForGETMethod(method: String, completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let parameters = [Parameters.Order : "\(Parameters.OrderDesc)\(JSONBodyKeys.UpdatedAt)"]
        let request = NSMutableURLRequest(URL:
            self.parseURLFromParameters(parameters, withPathExtension:method))
        request.addValue(ReqeustValues.XParseAppId, forHTTPHeaderField: RequestKeys.XParseAppId)
        request.addValue(ReqeustValues.XParseRestApiKey, forHTTPHeaderField: RequestKeys.XParseRestApiKey)
        
        return self.task(request, completionHandler: completionHandlerForGET)
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
    
    // shared instance
    override class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }

}
