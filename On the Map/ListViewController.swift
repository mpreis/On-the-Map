//
//  SecondViewController.swift
//  On the Map
//
//  Created by Mario Preishuber on 29/03/16.
//  Copyright © 2016 Preishuber. All rights reserved.
//

import UIKit

class ListViewController: NavBarButtonController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().userDataList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        
        let item = ParseClient.sharedInstance().userDataList[indexPath.row]
        cell.textLabel!.text = " \(item.getLastName()), \(item.getFirstName())"
        cell.imageView!.image = UIImage(named: "pin.pdf")
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let userData: UserData = ParseClient.sharedInstance().userDataList[indexPath.row]
        
        if userData == AppVariables.userData {
            let alert = UIAlertController(title: "", message: "What do you want to do?", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
           
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default) { action in
                switch action.style{
                case .Default:
                    ParseClient.sharedInstance().deleteUserData(userData.getObjectId()){
                        (success, errorString) in
                        print("DELETE: \(success) (objectId=\(userData.getObjectId()))")
                        performUIUpdatesOnMain {
                            ParseClient.sharedInstance().userDataList.removeAtIndex(indexPath.row)
                            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                        }
                    }
                    
                default:
                    print("ALERT-LISTVIEW: pressed delete, invalid case.")
                }
            })
            
            alert.addAction(UIAlertAction(title: "Open Link", style: .Default) { action in
                switch action.style{
                case .Default:
                    self.openLink(userData.getMediaURL())
                    
                default:
                    print("ALERT-LISTVIEW: pressed open link, invalid case")
                }
            })
        } else { self.openLink(userData.getMediaURL())}
    }
    
    
    private func openLink(link: String) {
        if let checkURL = NSURL(string: link) {
            print("Try to open: \(checkURL)")
            performUIUpdatesOnMain { UIApplication.sharedApplication().openURL(checkURL) }
        } else {
            print("invalid url: \(link)")
        }

    }

}

