//
//  SecondViewController.swift
//  On the Map
//
//  Created by Mario Preishuber on 29/03/16.
//  Copyright © 2016 Preishuber. All rights reserved.
//

import UIKit

class ListViewController: NavBarButtonController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ParseClient.sharedInstance().getStudentLocationList {
            (success, errorString) in
            if success {
                print(":)")
            } else {
                print(":(")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

