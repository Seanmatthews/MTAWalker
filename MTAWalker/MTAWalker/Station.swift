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
    
    var coordinate: CLLocationCoordinate2D!
    var routesHere: [String]!
    
    func milesFromStation() -> Double {
        return 0.0
    }
    
}

func ==(lhs: Station, rhs: Station) -> Bool {
    if let location = LocationService.sharedInstance.currentLocation {
        let leftStationLocation = CLLocation(latitude: lhs.coordinate.latitude,
            longitude: lhs.coordinate.longitude)
        let lhsDist = location.distanceFromLocation(leftStationLocation)
    }
    return true
}

func < (lhs: Station, rhs: Station) -> Bool {
    return true
}
