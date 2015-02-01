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
    var stations = [Station]()
    private var selectedStation: Station!
    private var imageMap = [
        "A": UIImage(named: "a.png"), "B": UIImage(named: "b.png"), "C": UIImage(named: "c.png"),
        "D": UIImage(named: "d.png"), "E": UIImage(named: "e.png"), "F": UIImage(named: "f.png"),
        "G": UIImage(named: "g.png"), "J": UIImage(named: "j.png"), "L": UIImage(named: "l.png"),
        "M": UIImage(named: "m.png"), "N": UIImage(named: "n.png"), "Q": UIImage(named: "q.png"),
        "R": UIImage(named: "r.png"), "S": UIImage(named: "s.png"), "Z": UIImage(named: "z.png"),
        "1": UIImage(named: "1.png"), "2": UIImage(named: "2.png"), "3": UIImage(named: "3.png"),
        "4": UIImage(named: "4.png"), "5": UIImage(named: "5.png"), "6": UIImage(named: "6.png"),
        "7": UIImage(named: "7.png")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TEST
//        stations = [Station]()
        var s = Station()
        s.routesHere = ["A", "C", "E"]
        stations.append(s)
        var s2 = Station()
        s2.routesHere = ["1"]
        stations.append(s2)
        var s3 = Station()
        s3.routesHere = ["E", "M"]
        stations.append(s3)
        var s4 = Station()
        s4.routesHere = ["N", "Q", "R"]
        stations.append(s4)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func unwindToRouteListView(segue: UIStoryboardSegue) {}
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "directionsMapSegue" {
            (segue.destinationViewController as DirectionsMapViewController).station = selectedStation
        }
    }
    
    // MARK - UITableViewDataSource functions
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("RouteCell") as UITableViewCell
            
            
            // Set cell height
            var frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y,
                cell.frame.width, tableView.frame.height / CGFloat(stations.count))
            cell.frame = frame
            
            // Set images
            let station = stations[indexPath.row]
            var i = 1
            let img = UIImage(named: "bg.png")
            for route in station.routesHere {
                // I'm also adding an image view behind each of the route logos,
                // so that the letters show up as white.
                let rect = (cell.viewWithTag(i) as UIImageView).frame
                var bgView = UIImageView(image: img)
                bgView.frame = rect
                cell.addSubview(bgView)
                cell.sendSubviewToBack(bgView)
                (cell.viewWithTag(i) as UIImageView).image = imageMap[route]!
                i++
            }
            
            // Set labels
            (cell.viewWithTag(20) as UILabel).text = station.milesFromStation().description + " miles"
            (cell.viewWithTag(30) as UILabel).text = "That's about two city avenues (the long ones)!"
            
            return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    
    // MARK - UITableViewDelegate functions
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(stations.count)
    }
    
    func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            selectedStation = stations[indexPath.row]
            self.performSegueWithIdentifier("directionsMapSegue", sender: self)
    }
    
}