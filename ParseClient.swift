//
//  ParseClient.swift
//  On the Map
//
//  Created by Mario Preishuber on 31/03/16.
//  Copyright © 2016 Preishuber. All rights reserved.
//

import Foundation

class ParseClient: NetworkUtils {
    
    var studentLocationList: [ParseStudentLocation] = []
    
    func taskForGETMethod(method: String, completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: self.parseURLFromParameters(method))
        request.addValue(ReqeustValues.XParseAppId, forHTTPHeaderField: RequestKeys.XParseAppId)
        request.addValue(ReqeustValues.XParseRestApiKey, forHTTPHeaderField: RequestKeys.XParseRestApiKey)
        
        return self.task(request, completionHandler: completionHandlerForGET)
    }
    
    // create a URL from parameters
    private func parseURLFromParameters(withPathExtension: String) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = ParseClient.APIConstants.ApiScheme
        components.host = ParseClient.APIConstants.ApiHost
        components.path = ParseClient.APIConstants.ApiPath + withPathExtension
        
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
