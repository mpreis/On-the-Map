//
//  TabBarViewController.swift
//  On the Map
//
//  Created by Mario Preishuber on 29/03/16.
//  Copyright © 2016 Preishuber. All rights reserved.
//

import UIKit

class TabBarViewContorler: UITabBarController {
    
    var createStudentLocation = false;
    var studLocLongitute: Double!
    var studLocLantitute: Double!
    var studLocLink: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(createStudentLocation) {
        
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

