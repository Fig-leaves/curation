//
//  TrackingManager.swift
//  Curation
//
//  Created by 伊藤総一郎 on 11/16/15.
//  Copyright © 2015 susieyy. All rights reserved.
//

import Foundation

class TrackingManager {
    
    class func sendScreenTracking(screenName: String) {

        var tracker = GAI.sharedInstance().defaultTracker;
        tracker.set(kGAIScreenName, value: screenName)
        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject])
        tracker.set(kGAIScreenName, value: nil)
    }
    
    class func sendEventTracking(category: String, action:String, label:String, value: NSNumber, screen:String) -> Void {
        var tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: screen)
        tracker.send(GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value).build() as [NSObject : AnyObject])
    }

}