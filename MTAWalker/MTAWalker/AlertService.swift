//
//  AlertService.swift
//  MTAWalker
//
//  Created by sean matthews on 1/31/15.
//  Copyright (c) 2015 Rowboat Entertainment. All rights reserved.
//

import Foundation
import AudioToolbox

// This class present the user with vibrations, beeps, and audio recordings
// during their navigation.
class AlertService {
    
    private var timer: dispatch_source_t!
    private var rightWay = true
    

    // Singleton
    class var sharedInstance : AlertService {
        struct Static {
            static let instance : AlertService = AlertService()
        }
        return Static.instance
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func wrongWayAlert() {
        for i in 0...4 {
            delay (Double(i)*0.4) {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
    }
    
    func rightWayPulse() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    private func stopRightWayPulse() {
        dispatch_suspend(timer)
    }
    
    func createDispatchTimer(interval: UInt64, leeway: UInt64,
        queue: dispatch_queue_t, block: dispatch_block_t) -> dispatch_source_t {
            if let t: dispatch_source_t  = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue) {
                dispatch_source_set_timer(t, dispatch_walltime(nil, 0), interval, leeway)
                dispatch_source_set_event_handler(t, block)
                dispatch_resume(t)
                return t
            }
            else {
                NSLog("NO TIMER")
            }
            return 0
    }
    
}