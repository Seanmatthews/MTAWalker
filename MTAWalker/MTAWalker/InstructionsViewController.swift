//
//  InstructionsViewController.swift
//  MTAWalker
//
//  Created by sean matthews on 2/3/15.
//  Copyright (c) 2015 Rowboat Entertainment. All rights reserved.
//

import Foundation
import UIKit

class InstructionsViewController : UIViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        var leftRight = UISwipeGestureRecognizer(target: self, action: "swiped")
        leftRight.direction = .Left | .Right
        leftRight.delegate = self
        self.view.addGestureRecognizer(leftRight)
        
        var upDown = UISwipeGestureRecognizer(target: self, action: "swiped")
        upDown.direction = .Up | .Down
        upDown.delegate = self
        self.view.addGestureRecognizer(upDown)
    }
    
    override func prefersStatusBarHidden() -> Bool { return true }
    
    func swiped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}