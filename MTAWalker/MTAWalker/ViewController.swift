//
//  ViewController.swift
//  MTAWalker
//
//  Created by sean matthews on 1/30/15.
//  Copyright (c) 2015 Rowboat Entertainment. All rights reserved.
//

import UIKit
import CoreLocation
import QuartzCore
//import AudioToolbox

class ViewController: UIViewController {
    
    private let orderedRoutes = ["1", "2", "3", "G", "4", "5", "6", "L", "A", "C", "E",
                                 "7", "B", "D", "F", "M", "N", "Q", "R", "S", "J", "Z"]

    private let colorMap = [
        "1": UIColor(rgba: "#EE352E"), "2": UIColor(rgba: "#EE352E"), "3": UIColor(rgba: "#EE352E"),
        "4": UIColor(rgba: "#00933C"), "5": UIColor(rgba: "#00933C"), "6": UIColor(rgba: "#00933C"),
        "7": UIColor(rgba: "#B933AD"),
        "A": UIColor(rgba: "#2850AD"), "C": UIColor(rgba: "#2850AD"), "E": UIColor(rgba: "#2850AD"),
        "B": UIColor(rgba: "#FF6319"), "D": UIColor(rgba: "#FF6319"), "F": UIColor(rgba: "#FF6319"), "M": UIColor(rgba: "#FF6319"),
        "G": UIColor(rgba: "#6CBE45"),
        "J": UIColor(rgba: "#996633"), "Z": UIColor(rgba: "#996633"),
        "L": UIColor(rgba: "#A7A9AC"),
        "N": UIColor(rgba: "#FCCC0A"), "Q": UIColor(rgba: "#FCCC0A"), "R": UIColor(rgba: "#FCCC0A"),
        "S": UIColor(rgba: "#808183")
    ]
    private var locationMap = [String: [Station]]()
    private var orderedStations: [Station] = [Station]()
    private var screenBounds: CGRect!
    private var closest: [Station] = [Station]()
    private var currentLocation: CLLocation!
    private var duplicateCheckMap = [String: Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        screenBounds = UIScreen.mainScreen().bounds
        
        var buttonLayout = determineButtonLayout()
        var buttonSize = determineButtonSize(buttonLayout)
        var buttons = createButtons(buttonSize, layout: buttonLayout)
        
        if buttonSize * Double(buttonLayout.0) < Double(screenBounds.height) {
            // We have unused vertical space-- add a title
            var space = CGFloat((Double(screenBounds.height) - buttonSize * Double(buttonLayout.0)))
            var title = UILabel(frame: CGRectMake(0, 0, screenBounds.width, space))
            title.text = "MTA Walker"
            
            // Move buttons down
            for b in buttons {
                var frame = b.frame
                frame.origin.y += space
                b.frame = frame
            }
        }
        else if buttonSize * Double(buttonLayout.1) < Double(screenBounds.width) {
            // We have unsued horizontal space-- center the buttons
            var space = CGFloat((Double(screenBounds.width) - buttonSize * Double(buttonLayout.1)) / 2.0)
            for b in buttons {
                var frame = b.frame
                frame.origin.x += space
                b.frame = frame
            }
        }

        for b in buttons {
            self.view.addSubview(b)
        }
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
        self.loadLocationData()
//        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        closest = [Station]()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMainView (segue : UIStoryboardSegue) {}
    
    override func prefersStatusBarHidden() -> Bool { return true }
    
    func determineButtonSize(layout: (Int, Int)) -> Double {
        // Fit the buttons (determine button size)
        let width = Double(screenBounds.width) / Double(layout.1)
        let height = Double(screenBounds.height) / Double(layout.0)
        return min(width, height)
    }
    
    func determineButtonLayout() -> (Int, Int) {
        // Determine screen buttons L/W ratio
        let possibleRatios = [(6.0, 4.0), (8.0, 3.0)]
        let screenRatio = Double(screenBounds.height / screenBounds.width)
        var bestRatio = (0.0, 1.0)
        for pr in possibleRatios {
            if fabs(pr.0/pr.1 - screenRatio) < fabs(bestRatio.0/bestRatio.1 - screenRatio) {
                bestRatio = pr
            }
        }
        return (Int(bestRatio.0), Int(bestRatio.1))
    }

    func createButtons(size: Double, layout: (Int, Int)) -> [UIButton] {
        var buttons = [UIButton]()
        var row = 0
        var column = 0
        for route in orderedRoutes {
            if column == layout.1 {
                column = 0
                row++
            }
            
            var bRect = CGRectMake(CGFloat(size)*CGFloat(column), CGFloat(size)*CGFloat(row), CGFloat(size), CGFloat(size))
            var b = UIButton(frame: bRect)
            b.setTitle(route, forState: .Normal)
            b.backgroundColor = colorMap[route]
            b.layer.borderColor = UIColor.blackColor().CGColor
            b.layer.borderWidth = 1.0
            b.addTarget(self, action: "pressedRouteButton:", forControlEvents: .TouchUpInside)
            buttons.append(b)
            column++
        }
        
        // Map button
        var mapButtonRect = CGRectMake(CGFloat(size)*CGFloat(column), CGFloat(size)*CGFloat(row), CGFloat(size), CGFloat(size))
        var mapButton = UIButton(frame: mapButtonRect)
        mapButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        mapButton.setTitle("MAP", forState: .Normal)
        mapButton.backgroundColor = UIColor.whiteColor()
        mapButton.layer.borderColor = UIColor.blackColor().CGColor
        mapButton.layer.borderWidth = 1.0
        mapButton.addTarget(self, action: "pressedMapButton:", forControlEvents: .TouchUpInside)
        buttons.append(mapButton)
        column++
        
        // Closest button
        var closestButtonRect = CGRectMake(CGFloat(size)*CGFloat(column), CGFloat(size)*CGFloat(row), CGFloat(size), CGFloat(size))
        var closestButton = UIButton(frame: closestButtonRect)
        closestButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        closestButton.setTitle("CLOSE", forState: .Normal)
        closestButton.backgroundColor = UIColor.whiteColor()
        closestButton.layer.borderColor = UIColor.blackColor().CGColor
        closestButton.layer.borderWidth = 1.0
        closestButton.addTarget(self, action: "pressedClosestButton:", forControlEvents: .TouchUpInside)
        buttons.append(closestButton)
        
        return buttons
    }
    
    // The location data for every station is simultaneously being loaded
    // into an ordered list of stations, as well as a map of all locations
    // for each route.    
    func loadLocationData() {
        let locationData = NSBundle.mainBundle().pathForResource("StationEntrances", ofType: "csv")!
        let locationStringData = String(contentsOfFile: locationData, encoding: NSUTF8StringEncoding, error: nil)!
        
        
//        let news = locationStringData.stringByReplacingOccurrencesOfString("\n", withString: ":")
//        println("\(news)")
//        var lines = split(locationStringData, {$0 == "\n"}, maxSplit: Int.max, allowEmptySlices: false)
        var lines = locationStringData.componentsSeparatedByString("\n")
        lines.removeAtIndex(0) // First line is column headers
        
        // Could probbaly do this with a map, but would be less readable
        for l in lines {
            if l == "" {
                continue
            }
            let items = split(l, {$0 == ","}, maxSplit: Int.max, allowEmptySlices: true)
            let coord = CLLocation(latitude: (items[3] as NSString).doubleValue, longitude: (items[4] as NSString).doubleValue)
            var s = Station()
            
            // Don't allow duplicates
            let keyString = String(items[3] + items[4])
            if let duplicate = duplicateCheckMap[keyString] {
                continue
            }
            else {
                duplicateCheckMap.updateValue(true, forKey: keyString)
            }

            s.coordinate = coord

            for i in items[5...15] { // the next 11 items are routes
                if i == "" {
                    break
                }
                var r = i.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).uppercaseString
                
                // These are the recorded names of the Franklin Shuttle,
                // Rockaway Shuttle, and Grand Central Shuttle, respectively.
                if r == "FS" || r == "H" || r == "GS" {
                    r = "S"
                }
    
                if let mapVal: AnyObject = locationMap[r] {
                    
                }
                else {
                    locationMap.updateValue([Station](), forKey: r)
                }
                
                // This looks weird, but it's adding routes to one station,
                // and mapping that station to several routes
                locationMap[r]!.append(s)
                s.routesHere.append(r)
            }
            orderedStations.append(s)
        }
        
        // Sort stations
//        orderedStations.sort{ return $0 < $1 }
        NSLog("Done loading data")
    }
    
    func pressedRouteButton(sender: UIButton) {
        LocationService.sharedInstance.stopService()
        var routeStations = locationMap[sender.currentTitle!]!
        routeStations.sort({ $0 < $1 })
        closest.extend(routeStations[0...3])
        for c in closest {
            println(c.coordinate)
        }
        LocationService.sharedInstance.startService()
        self.performSegueWithIdentifier("stationListSegue", sender: self)
    }
    
    func pressedMapButton(sender: UIButton) {
        AlertService.sharedInstance.rightWayPulse()
//        self.performSegueWithIdentifier("mapViewSegue", sender: self)
    }
    
    func pressedClosestButton(sender: UIButton) {
        AlertService.sharedInstance.wrongWayAlert()
//        LocationService.sharedInstance.stopService()
//        orderedStations.sort{ return $0 < $1 }
//        closest.extend(orderedStations[0...3])
//        LocationService.sharedInstance.startService()
//        self.performSegueWithIdentifier("stationListSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stationListSegue" {
            (segue.destinationViewController as RouteListViewController).stations = closest
        }
    }
}

func ==(lhs: CLLocation, rhs: CLLocation) -> Bool {
    return lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude
}

