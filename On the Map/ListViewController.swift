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
        return ParseClient.sharedInstance().studentLocationList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        
        let item = ParseClient.sharedInstance().studentLocationList[indexPath.row]
        cell.textLabel!.text = "\(item.firstName) \(item.lastName)"
        cell.imageView!.image = UIImage(named: "pin.pdf")
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        let mediaURL = ParseClient.sharedInstance().studentLocationList[indexPath.row].mediaURL
        guard let checkURL = NSURL(string: mediaURL) else {
            print("invalid url: \(mediaURL)")
            return
        }
        
        print("Try to open: \(checkURL)")
        UIApplication.sharedApplication().openURL(checkURL)
    }

}

