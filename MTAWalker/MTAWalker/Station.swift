//
//  Station.swift
//  MTAWalker
//
//  Created by sean matthews on 1/31/15.
//  Copyright (c) 2015 Rowboat Entertainment. All rights reserved.
//

import Foundation
import CoreLocation

// This class is primarily for transferring information to the route list
// view, and then again to the route map view.
class Station : NSObject, Comparable {
    
    var name: String!
    var coordinate: CLLocation!
    var routesHere = [String]()
    
    func milesFromStation() -> Double {
        if let loc = LocationService.sharedInstance.currentLocation {
            let dist = loc.distanceFromLocation(coordinate)
            return dist / 1609.344
        }
        return 0.0
    }
    
}


func ==(lhs: Station, rhs: Station) -> Bool {
    let location = LocationService.sharedInstance.currentLocation!
    let lhsDist = location.distanceFromLocation(lhs.coordinate)
    let rhsDist = location.distanceFromLocation(rhs.coordinate)
    return lhsDist == rhsDist
}

func < (lhs: Station, rhs: Station) -> Bool {
    let location = LocationService.sharedInstance.currentLocation!
    let lhsDist = location.distanceFromLocation(lhs.coordinate)
    let rhsDist = location.distanceFromLocation(rhs.coordinate)
    return lhsDist < rhsDist
}
