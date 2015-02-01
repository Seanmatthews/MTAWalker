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
    
    // This will only ever happen after a user has selected a cell
    // on the route list table view. All necessary info to create
    // the route will be set
    override func viewWillAppear(animated: Bool) {
        
    }
}