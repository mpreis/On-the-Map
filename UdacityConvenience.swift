//
//  UdacityConvenience.swift
//  On the Map
//
//  Created by Mario Preishuber on 29/03/16.
//  Copyright © 2016 Preishuber. All rights reserved.
//

import UIKit
import Foundation

extension UdacityClient {
    
    func authenticateWithViewController(username: String, password: String, completionHandlerForAuth: (success: Bool, errorString: String?) -> Void) {
        
        getSessionID(username, password: password) { (success, sessionID, errorString) in
            
            if success {
                // success! we have the sessionID!
                print("SUCCESS: Session-Id")
                self.sessionID = sessionID
                completionHandlerForAuth(success: true, errorString: nil)
            } else {
                print("FAILED")
                completionHandlerForAuth(success: false, errorString: errorString)
            }
        }
    
    }
    
    private func getSessionID(username: String, password: String, completionHandlerForToken: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
    
        let jsonBody = "{\"\(UdacityClient.JSONBodyKeys.Udacity)\":{\"\(UdacityClient.JSONBodyKeys.Username)\":\"\(username)\",\"\(UdacityClient.JSONBodyKeys.Password)\":\"\(password)\"}}"
        
        /* 2. Make the request */
        taskForPOSTMethod(Methods.Session, jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForToken(success: false, sessionID: nil, errorString: "Login Failed (SessionID).")
            } else {
                
                guard let session = results[UdacityClient.JSONResponseKeys.Session] as? [String:AnyObject] else {
                    print("Could not find \(UdacityClient.JSONResponseKeys.Session) in \(results)")
                    completionHandlerForToken(success: false, sessionID: nil, errorString: "Login Failed (SessionID).")
                    return
                }
                
                guard let sessionID = session[UdacityClient.JSONResponseKeys.Id] as? String else {
                    print("Could not find \(UdacityClient.JSONResponseKeys.Id) in \(session)")
                    completionHandlerForToken(success: false, sessionID: nil, errorString: "Login Failed (SessionID).")
                    return
                }
                
                completionHandlerForToken(success: true, sessionID: sessionID, errorString: nil)
            }
        }
        
    }
}
