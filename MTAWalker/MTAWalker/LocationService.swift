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
    var lastSignificantLocation: CLLocation?
    var trackingUser = false
    var destination: CLLocation!
//    private let significantChangeDistance
    
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
        locationManager.distanceFilter = 10.0
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        NSLog("location service started")
    }
    
    func stopService() {
        locationManager.stopUpdatingLocation()
        NSLog("location service stopped")
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
        currentLocation = locationArray.lastObject as? CLLocation
        currentCoord = currentLocation!.coordinate
        
        if let coord: CLLocationCoordinate2D = currentCoord {
            println(coord.latitude)
            println(coord.longitude)
            if isValidCoord(coord) {
                if trackingUser {
                    if let last = lastSignificantLocation {
                        // Last significant location changes once the walker covers
                        // a distance 
                        if currentLocation!.distanceFromLocation(destination) >
                            last.distanceFromLocation(destination) {
                                // Buzz crazy
                                AlertService.sharedInstance.wrongWayAlert()
                        }
                        else {
                            // One pulse
                            AlertService.sharedInstance.rightWayPulse()
                        }
                        
                    }
                    // Create a baseline
                    lastSignificantLocation = currentLocation
                }
            }
        }
    }
}