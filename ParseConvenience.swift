//
//  ParseConvenience.swift
//  On the Map
//
//  Created by Mario Preishuber on 31/03/16.
//  Copyright © 2016 Preishuber. All rights reserved.
//

import Foundation

extension ParseClient {

    func getUserLocationList(completionHandlerForStudLocList: (success: Bool, userDataList: [UserData], errorString: String?) -> Void) {
        
        let params = [Parameters.Order : "\(Parameters.OrderDesc)\(JSONBodyKeys.UpdatedAt)"]
        
        taskForGETMethod(Methods.StudentLocation, parameters: params) { (results, error) in
            if let error = error {
                print("FAILED: Get Student Location List")
                completionHandlerForStudLocList(success: false, userDataList: [], errorString: error.description)
            } else {
                print("SUCCESS: Get Student Location List")
                
                if let results = results[ParseClient.JSONBodyKeys.Results] as? [[String:AnyObject]] {
                    let userDataList = UserData.studentLocationFromResults(results)
                    completionHandlerForStudLocList(success: true, userDataList: userDataList, errorString: nil)
                } else {
                    completionHandlerForStudLocList(success: false, userDataList: [], errorString: "Could not parse getStudentLocationList")
                }
            }
        }
    }
    
    func getUserData(uniqueKey: String, completionHandlerForUserData: (success: Bool, userData: UserData?, errorString: String?) -> Void) {
        
        let params = [Parameters.Where : "\(JSONBodyKeys.UniqueKey)=\(uniqueKey)"]
        taskForGETMethod(Methods.StudentLocation, parameters: params) { (results, error) in
            if let error = error {
                print("FAILED: Get Student Location")
                completionHandlerForUserData(success: false, userData: nil, errorString: error.description)
            } else {
                print("SUCCESS: Get Student Location")
                print(results)
                
                if let results = results[ParseClient.JSONBodyKeys.Results] as? [String:AnyObject] {
                    let userData = UserData(dictionary: results)
                    completionHandlerForUserData(success: true, userData: userData, errorString: nil)
                } else {
                    completionHandlerForUserData(success: false, userData: nil, errorString: "Could not parse getStudentLocationList")
                }
            }
        }
    }
    
    func setUserData(completionHandlerForSetUserData: (success: Bool, errorString: String?) -> Void) {
        if(AppVariables.userData.exsistsPin()) {
            updateUserData() {(success, updatedAt, errorString) in
                if success {
                    print("SUCCESS: Update User Data")
                    AppVariables.userData.setUpdatedAt(updatedAt!)
                    completionHandlerForSetUserData(success: true, errorString: nil)
                } else {
                    print("FAILED: \(errorString)")
                    completionHandlerForSetUserData(success: false, errorString: errorString)
                }
            }
        } else {
            createUserData() {(success, objectId, createdAt, errorString) in
                if success  {
                    print("SUCCESS: Create User Data (ObjectID: \(objectId!)")
                    AppVariables.userData.setObjectId(objectId!)
                    AppVariables.userData.setCreatedAt(createdAt!)
                    completionHandlerForSetUserData(success: true, errorString: nil)
                } else {
                    print("FAILED: \(errorString)")
                    completionHandlerForSetUserData(success: false, errorString: errorString)
                }
            }
        }
    }
    
    private func createUserData(completionHandlerForCreateUserData: (success: Bool, objectId: String?, createdAt: String?, errorString: String?) -> Void) {
        
        self.taskForPOSTMethod(Methods.StudentLocation, jsonBody: self.userDataToJSONBody()) { (result, error) in
            if let error = error {
                completionHandlerForCreateUserData(success: false, objectId: nil, createdAt: nil, errorString: error.description)
            } else {
                guard let objectId = result[ParseClient.JSONBodyKeys.ObjectId] as? String else {
                    completionHandlerForCreateUserData(success: false, objectId: nil, createdAt: nil, errorString: "Could not parse result.")
                    return
                }
                
                guard let createAt = result[ParseClient.JSONBodyKeys.CreatedAt] as? String else {
                    completionHandlerForCreateUserData(success: false, objectId: nil, createdAt: nil, errorString: "Could not parse result.")
                    return
                }
                
                completionHandlerForCreateUserData(success: true, objectId: objectId, createdAt: createAt, errorString: nil)
            }
        }
    }
    
    private func updateUserData(completionHandlerForUpdateUserData: (success: Bool, updatedAt: String?, errorString: String?) -> Void) {
        
        let method = "\(Methods.StudentLocation)/\(AppVariables.userData.getObjectId())"
        self.taskForPUTMethod(method, jsonBody: self.userDataToJSONBody()) { (result, error) in
            if let error = error {
                completionHandlerForUpdateUserData(success: false, updatedAt: nil, errorString: error.description)
            } else {
                guard let updatedAt = result[ParseClient.JSONBodyKeys.UpdatedAt] as? String else {
                    completionHandlerForUpdateUserData(success: false, updatedAt: nil, errorString: "Could not parse result.")
                    return
                }
                
                completionHandlerForUpdateUserData(success: true, updatedAt: updatedAt, errorString: nil)
            }
        }
    }
    
    
}