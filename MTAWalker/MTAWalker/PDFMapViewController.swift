//
//  PDFMapViewController.swift
//  MTAWalker
//
//  Created by sean matthews on 1/30/15.
//  Copyright (c) 2015 Rowboat Entertainment. All rights reserved.
//

import Foundation
import UIKit

class PDFMapViewController : UIViewController {
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.backgroundColor = UIColor.blackColor()
        
        //http://web.mta.info/maps/
        var url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("subwaymap", ofType: "pdf")!)!
        webView.scrollView.zoomScale = 3.0

        webView.loadRequest(NSURLRequest(URL: url))
        
        // Doesn't work
        //        webView.scrollView.bounces = false
        //        webView.scrollView.bouncesZoom = false
        //        webView.scrollView.scrollEnabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        var js =
        "var meta = document.createElement('meta'); meta.setAttribute( 'name', 'viewport' ); meta.setAttribute( 'content', 'width = device-width, initial-scale = 5.0, user-scalable = yes' ); document.getElementsByTagName('head')[0].appendChild(meta)"
        
        webView.stringByEvaluatingJavaScriptFromString(js)
        webView.scrollView.zoomScale = 3.0
    }

}