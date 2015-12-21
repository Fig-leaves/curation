//
//  AppDelegate.swift
//  RSSReader
//
//  Created by susieyy on 2014/06/03.
//  Copyright (c) 2014年 susieyy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    var newsView : Bool = false
    var blogView : Bool = false
    var newsItem = NSMutableArray()
    var blogItem = NSMutableArray()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        
        let myNativeBoundSize: CGSize = UIScreen.mainScreen().nativeBounds.size
        var storyboard : UIStoryboard!
        
        GAI.sharedInstance().trackerWithTrackingId(Constants.analytics.TRACK_ID)
        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().dispatchInterval = 20
        GAI.sharedInstance().logger.logLevel=GAILogLevel.Info
        
        print(myNativeBoundSize.width)
        if myNativeBoundSize.width == 640 {
            storyboard =  UIStoryboard(name: "Main",bundle:nil)
        } else if myNativeBoundSize.width == 750 {
            storyboard =  UIStoryboard(name: "iphone6",bundle:nil)
        } else {
            storyboard =  UIStoryboard(name: "iphone6plus",bundle:nil)
        }
        
        var viewController:UIViewController

        viewController = storyboard.instantiateViewControllerWithIdentifier("Main")
        self.window?.rootViewController = viewController
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent

    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

