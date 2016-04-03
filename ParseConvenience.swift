//
//  ParseConvenience.swift
//  On the Map
//
//  Created by Mario Preishuber on 31/03/16.
//  Copyright © 2016 Preishuber. All rights reserved.
//

import Foundation

extension ParseClient {

    func getStudentLocationList(completionHandlerForStudLocList: (success: Bool, studLocs: [ParseStudentLocation], errorString: String?) -> Void) {
        
        taskForGETMethod(Methods.StudentLocation) { (results, error) in
            if let error = error {
                print("FAILED: Get Student Location List")
                completionHandlerForStudLocList(success: false, studLocs: [], errorString: error.description)
            } else {
                print("SUCCESS: Get Student Location List")
                
                if let results = results[ParseClient.JSONBodyKeys.Results] as? [[String:AnyObject]] {
                    let studLocs = ParseStudentLocation.studentLocationFromResults(results)
                    completionHandlerForStudLocList(success: true, studLocs: studLocs, errorString: nil)
                } else {
                    completionHandlerForStudLocList(success: false, studLocs: [], errorString: "Could not parse getStudentLocationList")
                }
            }
        }
    }
}