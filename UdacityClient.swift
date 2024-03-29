//
//  UdacityClient.swift
//  On the Map
//
//  Created by Mario Preishuber on 29/03/16.
//  Copyright © 2016 Preishuber. All rights reserved.
//

import Foundation

class UdacityClient : NetworkUtils {
    
    func taskForDELETEMethod(method: String, completionHandlerForDELETE: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: udacityURLWithPathExtension(method))
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        return task(request, completionHandler: completionHandlerForDELETE)
    }
    
    
    func taskForGETMethod(method: String, pathExtension: String, completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let url = udacityURLWithPathExtension(method, withPathExtension: pathExtension)
        return self.task(
            NSMutableURLRequest(URL: url),
            completionHandler: completionHandlerForGET)
    }
    
    func taskForPOSTMethod(method: String, jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: udacityURLWithPathExtension(method))
        request.HTTPMethod = "POST"
        requestAddValueContentTypes(request)
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        return self.task(request, completionHandler: completionHandlerForPOST)

    }
    
    override func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
        super.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForConvertData)
    
    }

    // create a URL from parameters
    private func udacityURLWithPathExtension(withPathExtension: String) -> NSURL {
        let components = NSURLComponents()
        components.scheme = UdacityClient.APIConstants.ApiScheme
        components.host = UdacityClient.APIConstants.ApiHost
        components.path = UdacityClient.APIConstants.ApiPath + withPathExtension
        
        return components.URL!
    }
    
    private func udacityURLWithPathExtension(method: String, withPathExtension: String) -> NSURL {
        return udacityURLWithPathExtension("\(method)/\(withPathExtension)")
    }
    
    // shared instance
    override class func sharedInstance() -> UdacityClient {
        struct Singleton { static var sharedInstance = UdacityClient() }
        return Singleton.sharedInstance
    }
}
