//
//  SwiftCoordinate.swift
//  MTAWalker
//
//  Created by sean matthews on 1/30/15.
//  Copyright (c) 2015 Rowboat Entertainment. All rights reserved.
//

import Foundation
import CoreLocation

class SwiftCoordinate : NSObject {
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    required init(latitude: Double, longitude: Double) {
        super.init()
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func oldCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.latitude, self.longitude)
    }
}