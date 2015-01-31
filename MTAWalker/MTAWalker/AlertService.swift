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
    
    // Singleton
    class var sharedInstance : AlertService {
        struct Static {
            static let instance : AlertService = AlertService()
        }
        return Static.instance
    }
    
    func wrongWayAlert() {
        stopRightWayPulse()
    }
    
    func rightWayPulse() {
        timer = createDispatchTimer(5*NSEC_PER_SEC, leeway: NSEC_PER_SEC,
            queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block: {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        })
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