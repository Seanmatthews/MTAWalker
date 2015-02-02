//
//  DirectionsMapViewController.swift
//  MTAWalker
//
//  Created by sean matthews on 1/31/15.
//  Copyright (c) 2015 Rowboat Entertainment. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DirectionsMapViewController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    var station: Station!
    private var directions: MKDirections!
    private var directionsReq: MKDirectionsRequest!
    private var source: MKMapItem!
    private var destination: MKMapItem!

    override func viewDidLoad() {
//        mapView.userTrackingMode = .FollowWithHeading
        mapView.setUserTrackingMode(.FollowWithHeading, animated: true)
    }
    
    // This will only ever happen after a user has selected a cell
    // on the route list table view. All necessary info to create
    // the route will be set
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        LocationService.sharedInstance.trackingUser = true
        directionsReq = MKDirectionsRequest()
        source = MKMapItem.mapItemForCurrentLocation()
        destination = MKMapItem(placemark:
            MKPlacemark(coordinate: station.coordinate.coordinate,
                addressDictionary: nil))
        directionsReq.setSource(source)
        directionsReq.setDestination(destination)
        directionsReq.transportType = .Walking
        directions = MKDirections(request: directionsReq)
        directions.calculateDirectionsWithCompletionHandler{
            (walkingRouteResponse: MKDirectionsResponse!, error: NSError!) in
//            if error == nil {
                let route = walkingRouteResponse.routes[0] as MKRoute
                self.mapView.addOverlay(route.polyline, level:.AboveRoads)
//            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        LocationService.sharedInstance.trackingUser = false
    }
    
    override func prefersStatusBarHidden() -> Bool { return true }
    
    func mapView(mapView: MKMapView!,
        rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
            if (overlay is MKPolyline) {
                var pr = MKPolylineRenderer(overlay: overlay)
                pr.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
                pr.lineWidth = 5
                return pr
            }
            
            return nil
    }
}