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
    private var locationMap = [String: [SwiftCoordinate]]()
    var screenBounds: CGRect!
    
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
        
//        println("\(screenBounds)")
//        println("\(buttonLayout)")
//        println("\(buttonSize)")

        for b in buttons {
            self.view.addSubview(b)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMainView (segue : UIStoryboardSegue) {}
    
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
    
    func loadLocationData() {
        let locationData = NSBundle.mainBundle().pathForResource("StationEntrances", ofType: "csv")!
        let locationStringData = String(contentsOfFile: locationData, encoding: NSUTF8StringEncoding, error: nil)!
        var lines = split(locationStringData, {$0 == "\n"}, maxSplit: Int.max, allowEmptySlices: false)
        lines.removeAtIndex(0) // First line is column headers

        // Could probbaly do this with a map, but would be less readable
        for l in lines {
            let items = split(l, {$0 == ","}, maxSplit: Int.max, allowEmptySlices: true)
            let coord = SwiftCoordinate(latitude: (items[3] as NSString).doubleValue,
                longitude: (items[4] as NSString).doubleValue)
            for i in items[5...15] { // the next 11 items are routes
                if i == "" {
                    break
                }
                if let mapVal: AnyObject = locationMap[i] {
                    
                }
                else {
                    locationMap.updateValue([SwiftCoordinate](), forKey: i)
                }
                locationMap[i]!.append(coord)
            }
        }
    }
    
    func pressedRouteButton(sender: UIButton) {
        self.performSegueWithIdentifier("stationListSegue", sender: self)
    }
    
    func pressedMapButton(sender: UIButton) {
        self.performSegueWithIdentifier("mapViewSegue", sender: self)
    }
    
    func pressedClosestButton(sender: UIButton) {
        self.performSegueWithIdentifier("stationListSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stationListSegue" {
            
        }
    }
}

