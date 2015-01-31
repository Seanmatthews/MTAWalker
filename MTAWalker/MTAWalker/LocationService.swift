//
//  LocationService.swift
//  MTAWalker
//
//  Created by sean matthews on 1/31/15.
//  Copyright (c) 2015 Rowboat Entertainment. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService : NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var currentCoord: CLLocationCoordinate2D? = nil
    var currentLocation: CLLocation? = nil
    
    // Singleton
    class var sharedInstance : LocationService {
        struct Static {
            static let instance : LocationService = LocationService()
        }
        return Static.instance
    }
    
    func startService() {
        // TODO add values to plist
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        println("location service started")
    }
    
    func isValidCoord(coord: CLLocationCoordinate2D) -> Bool {
        if coord.latitude > 90.0 ||
            coord.latitude < -90.0 ||
            coord.longitude > 180.0 ||
            coord.longitude < -180.0 {
                return false
        }
        return true
    }
    
    
    // CLLocationManagerDelegate functions
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locationArray = locations as NSArray
        currentLocation = locationArray.lastObject as CLLocation
        currentCoord = currentLocation!.coordinate
        
        if let coord: CLLocationCoordinate2D = currentCoord {
            println(coord.latitude)
            println(coord.longitude)
            if isValidCoord(coord) {
                
            }
        }
    }
}