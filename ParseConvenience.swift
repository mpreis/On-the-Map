//
//  ParseConvenience.swift
//  On the Map
//
//  Created by Mario Preishuber on 31/03/16.
//  Copyright © 2016 Preishuber. All rights reserved.
//

import Foundation

extension ParseClient {

    func getStudentLocationList(completionHandlerForStudLocList: (success: Bool, errorString: String?) -> Void) {
        
        taskForGETMethod(Methods.StudentLocation) { (results, error) in
            if let error = error {
                print("FAILED: Get Student Location List")
                completionHandlerForStudLocList(success: false, errorString: error.description)
            } else {
                print("SUCCESS: Get Student Location List")
                // self.studentLocationList = getStudentList(results)
                //print(results)
                completionHandlerForStudLocList(success: true, errorString: nil)
            }
        }
    }
}