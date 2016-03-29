//
//  UdacityClient.swift
//  On the Map
//
//  Created by Mario Preishuber on 29/03/16.
//  Copyright © 2016 Preishuber. All rights reserved.
//

import Foundation

class UdacityClient : NSObject {
    
    // Properties
    
    // shared session
    var session = NSURLSession.sharedSession()
    
    // authentication state
    var sessionID : String? = nil
    
    /*
    func taskForDELETEMethod(method: String, completionHandlerForDELETE: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        return nil
    }
    */
    
    func taskForGETMethod(method: String, completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        /* 2/3. Build the URL, Configure the request */
        return self.task(
            NSMutableURLRequest(URL: udacityURLFromParameters(method)),
            completionHandler: completionHandlerForGET)
    }
    
    func taskForPOSTMethod(method: String, jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        /* 1. Set the parameters */
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: udacityURLFromParameters(method))
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        return task(request, completionHandler: completionHandlerForPOST)

    }
    
    private func task(request: NSMutableURLRequest, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(result: nil, error: NSError(domain: "task", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandler)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    

    // create a URL from parameters
    private func udacityURLFromParameters(withPathExtension: String) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + withPathExtension
        components.queryItems = [NSURLQueryItem]()
        
        return components.URL!
    }

    
    // shared instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }


}