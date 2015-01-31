//
//  RouteListTableViewController.swift
//  MTAWalker
//
//  Created by sean matthews on 1/31/15.
//  Copyright (c) 2015 Rowboat Entertainment. All rights reserved.
//

import Foundation
import UIKit

class RouteListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    var routes: [Station]!
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    
    // MARK - UITableViewDataSource functions
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("RouteCell") as UITableViewCell
            
            return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return routes.count
    }
    
}