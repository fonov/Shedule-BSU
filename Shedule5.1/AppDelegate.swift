//
//  AppDelegate.swift
//  Shedule5.1
//
//  Created by kotmodell on 09.02.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.shedule")!
    let nc = NSNotificationCenter.defaultCenter()
    
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        if let _ = defaults.objectForKey("hidehellovc"){
            
        }else{
            window =  UIWindow(frame: UIScreen.mainScreen().bounds)
            window?.makeKeyAndVisible()
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc : HelloViewController = mainStoryboard.instantiateViewControllerWithIdentifier("HelloViewController") as! HelloViewController
            if let window = self.window {
                window.rootViewController = vc
            }
        }

        let pagecontroller = UIPageControl.appearance()
        pagecontroller.pageIndicatorTintColor = UIColor.lightGrayColor()
        pagecontroller.currentPageIndicatorTintColor = UIColor.blackColor()
        pagecontroller.backgroundColor = UIColor.whiteColor()
        
        return true
    }


    func applicationWillResignActive(application: UIApplication) {
        nc.postNotificationName("funcchromtimerstop", object: nil)
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        nc.postNotificationName("funcchromtimerstart", object: nil)
        nc.postNotificationName("funcupdateactualsection", object: nil)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

