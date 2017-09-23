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
    let defaults: UserDefaults = UserDefaults(suiteName: "group.com.shedule")!
    let nc = NotificationCenter.default
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let _ = defaults.object(forKey: "hidehellovc"){
            
        }else{
            window =  UIWindow(frame: UIScreen.main.bounds)
            window?.makeKeyAndVisible()
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc : HelloViewController = mainStoryboard.instantiateViewController(withIdentifier: "HelloViewController") as! HelloViewController
            if let window = self.window {
                window.rootViewController = vc
            }
        }

        let pagecontroller = UIPageControl.appearance()
        pagecontroller.pageIndicatorTintColor = UIColor.lightGray
        pagecontroller.currentPageIndicatorTintColor = UIColor.black
        pagecontroller.backgroundColor = UIColor.white
        
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        nc.post(name: Notification.Name(rawValue: "funcchromtimerstop"), object: nil)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        nc.post(name: Notification.Name(rawValue: "funcchromtimerstart"), object: nil)
        nc.post(name: Notification.Name(rawValue: "funcupdateactualsection"), object: nil)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

