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
                print("SUCCESS: Login (Session-Id)")
                self.sessionID = sessionID
                completionHandlerForAuth(success: true, errorString: nil)
            } else {
                print("FAILED: Login")
                completionHandlerForAuth(success: false, errorString: errorString)
            }
        }
    
    }
    
    func logout(completionHandlerForLogout: (success: Bool, errorString: String?) -> Void) {
        taskForDELETEMethod(Methods.Session) { (results, error) in
            if let error = error {
                print("FAILED: Logout")
                completionHandlerForLogout(success: false, errorString: error.description)
            } else {
                print("SUCCESS: Logout")
                self.sessionID = nil
                completionHandlerForLogout(success: true, errorString: nil)
            }
        }
    }
    
    private func getSessionID(username: String, password: String, completionHandlerForSession: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
    
        let jsonUsr = "\"\(UdacityClient.JSONBodyKeys.Username)\":\"\(username)\""
        let jsonPwd = "\"\(UdacityClient.JSONBodyKeys.Password)\":\"\(password)\""
        let jsonBody = "{\"\(UdacityClient.JSONBodyKeys.Udacity)\":{\(jsonUsr),\(jsonPwd)}}"
        
        taskForPOSTMethod(Methods.Session, jsonBody: jsonBody) { (results, error) in
            
            if let error = error {
                print(error)
                completionHandlerForSession(success: false, sessionID: nil, errorString: "Login Failed (SessionID).")
            } else {
                
                guard let session = results[UdacityClient.JSONResponseKeys.Session] as? [String:AnyObject] else {
                    print("Could not find \(UdacityClient.JSONResponseKeys.Session) in \(results)")
                    completionHandlerForSession(success: false, sessionID: nil, errorString: "Login Failed (SessionID).")
                    return
                }
                
                guard let sessionID = session[UdacityClient.JSONResponseKeys.Id] as? String else {
                    print("Could not find \(UdacityClient.JSONResponseKeys.Id) in \(session)")
                    completionHandlerForSession(success: false, sessionID: nil, errorString: "Login Failed (SessionID).")
                    return
                }
                
                guard let account = results[UdacityClient.JSONResponseKeys.Account] as? [String:AnyObject] else {
                    print("Could not find \(UdacityClient.JSONResponseKeys.Account) in \(session)")
                    completionHandlerForSession(success: false, sessionID: nil, errorString: "Login Failed (SessionID).")
                    return
                }
                
                guard let uniqueKey = account[UdacityClient.JSONResponseKeys.Key] as? String else {
                    print("Could not find \(UdacityClient.JSONResponseKeys.Key) in \(session)")
                    completionHandlerForSession(success: false, sessionID: nil, errorString: "Login Failed (SessionID).")
                    return
                }
                
                
                self.getPublicUserData(uniqueKey) { (success, userData, errorString) in
                    if(success) {
                        print("SUCCESS: Get User Data")
                        print(userData)
                        completionHandlerForSession(success: true, sessionID: sessionID, errorString: nil)
                    } else {
                        print("FAILED: \(errorString)")
                        completionHandlerForSession(success: false, sessionID: nil, errorString: errorString)
                    }
                }
                
                
                
            }
        }
        
    }
    
    private func getPublicUserData(uniqueKey: String, completionHandlerForUsrData: (success: Bool, userData: UserData?, errorString: String?) -> Void) {
        
        let method = "\(Methods.UserData)/\(uniqueKey)"
        taskForGETMethod(method) { (results, error) in
            
            if let error = error {
                print(error)
                completionHandlerForUsrData(success: false, userData: nil, errorString: "Get Public User Data Failed.")
            } else {
                guard let user = results[JSONResponseKeys.User] as? [String:AnyObject] else {
                    print("Could not find \(JSONResponseKeys.User) in \(results)")
                    completionHandlerForUsrData(success: false, userData: nil, errorString: "Get Public User Data Failed.")
                    return
                }
                
                guard let firstName = user[JSONResponseKeys.FirstName] as? String else {
                    print("Could not find \(JSONResponseKeys.FirstName) in \(results)")
                    completionHandlerForUsrData(success: false, userData: nil, errorString: "Get Public User Data Failed.")
                    return
                }
                
                guard let lastName = user[JSONResponseKeys.LastName] as? String else {
                    print("Could not find \(JSONResponseKeys.FirstName) in \(results)")
                    completionHandlerForUsrData(success: false, userData: nil, errorString: "Get Public User Data Failed.")
                    return
                }
                
                completionHandlerForUsrData(success: true, userData: UserData(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName), errorString: nil)
            }
        }
    }
 
}
