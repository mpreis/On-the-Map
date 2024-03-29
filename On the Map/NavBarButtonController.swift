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
        print("PRESSED: Logout")
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
        print("PRESSED: Pin")
        if(AppVariables.userData.exsistsPin()) {
            let alert = UIAlertController(title: "", message: "You have already posted a location. Would you like to override your location?", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Overwrite", style: .Default) { action in
                switch action.style{
                case .Default:
                    self.presentViewController(
                        self.storyboard!.instantiateViewControllerWithIdentifier("LocationViewController"),
                        animated: true, completion: nil)
                    
                default:
                    print("ALERT: pressed overwrite invalid case.")
                }
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            
        } else {
            self.presentViewController(
                self.storyboard!.instantiateViewControllerWithIdentifier("LocationViewController"),
                animated: true, completion: nil)

        }
    }
    
    private func setNavigationBarButtons(view: UIViewController) {
        let logoutBtn = UIBarButtonItem(
            title: "Logout",
            style: .Plain,
            target: view,
            action: #selector(NavBarButtonController.logoutPressed(_:))
        )
        view.navigationItem.leftBarButtonItem = logoutBtn
        
        let pinBtn = UIBarButtonItem(
            image: UIImage(named: "pin.pdf"),
            style: .Plain,
            target: view,
            action: #selector(NavBarButtonController.pinPressed(_:))
        )
        view.navigationItem.rightBarButtonItem = pinBtn
    }
    

    private func completeLogout() {
        performUIUpdatesOnMain {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }


}