//
//  NavBarController.swift
//  On the Map
//
//  Created by Mario Preishuber on 30/03/16.
//  Copyright © 2016 Preishuber. All rights reserved.
//

import UIKit

class NavBarButtonController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarButtons(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Login
    @IBAction func logoutPressed(sender: AnyObject) {
        //self.setUIEnabled(true)
        UdacityClient.sharedInstance().logout { (success, errorString) in
            performUIUpdatesOnMain {
                if success {
                    self.completeLogout()
                } else {
                    //self.displayError(errorString)
                    //self.setUIEnabled(true)
                }
            }
        }

    }
    
    // Login
    @IBAction func pinPressed(sender: AnyObject) {
        print("pin")
    }
    
    private func setNavigationBarButtons(view: UIViewController) {
        let logoutBtn = UIBarButtonItem(
            title: "Logout",
            style: .Plain,
            target: view,
            action: "logoutPressed:"
        )
        view.navigationItem.leftBarButtonItem = logoutBtn
        
        let pinBtn = UIBarButtonItem(
            image: UIImage(named: "pin.pdf"),
            style: .Plain,
            target: view,
            action: "pinPressed:"
        )
        view.navigationItem.rightBarButtonItem = pinBtn
    }
    

    private func completeLogout() {
        performUIUpdatesOnMain {
            //self.debugTextLabel.text = ""
            //self.setUIEnabled(true)
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }


}