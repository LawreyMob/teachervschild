//
//  LoadingOverlay.swift
//  eatlist
//
//  Created by 2359 Lawrence on 23/6/16.
//  Copyright © 2016 2359 Media Pte Ltd. All rights reserved.
//

import Foundation
import UIKit

public class HKSLoading {
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: HKSLoading {
        struct Static {
            static let instance: HKSLoading = HKSLoading()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView) {
        overlayView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        overlayView.addSubview(activityIndicator)
        
        view.addSubview(overlayView)
        view.bringSubview(toFront: overlayView)
        
        activityIndicator.startAnimating()
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
