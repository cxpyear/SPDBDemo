//
//  AppDelegate.swift
//  spdbapp
//
//  Created by tommy on 15/5/7.
//  Copyright (c) 2015年 shgbit. All rights reserved.
//

import UIKit
import Fabric
//import Crashlytics


var server = Server()
var builder = Builder()
var appManager = AppManager()

var appDelegate = AppDelegate()




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var initserver = Server()
    var initAppManager = AppManager()
    
//    var lastIsClearHistoryInfo: Bool = false
//    var lastIsClearConfigInfo: Bool  = false
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//        Fabric.with([Crashlytics.self()])
 
        server = initserver
        appManager = initAppManager
        
//        
//        var standardDefaults = NSUserDefaults.standardUserDefaults()
//        lastIsClearHistoryInfo = standardDefaults.boolForKey("clear_historyInfo")
//        lastIsClearConfigInfo = standardDefaults.boolForKey("clear_configInfo")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "defaultsSettingsChanged:", name: UIApplicationWillEnterForegroundNotification, object: nil)
//        NSUserDefaultsDidChangeNotification
        return true
    }



    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func defaultsSettingsChanged(notification: NSNotification) {
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        
        // 监听txtFileURL是否发生改变  默认情况下是192.168.16.142
        var value = standardDefaults.stringForKey("txtBoxURL")
        println("url new value ============ \(value)")
        
        
        var isClearHistoryInfo = standardDefaults.boolForKey("clear_historyInfo")
        if isClearHistoryInfo == true {
            //重置设置页面的值
            standardDefaults.setBool(false, forKey: "clear_historyInfo")
            standardDefaults.synchronize()
            
            server.clearHistoryInfo("pdf")
            
            
//            UIAlertView(title: "tishi", message: "tishi", delegate: UIApplication.sharedApplication(), cancelButtonTitle: "queding").show()
        }
        
        var isClearConfigInfo = standardDefaults.boolForKey("clear_configInfo")
        if isClearConfigInfo == true{
            standardDefaults.setBool(false, forKey: "clear_configInfo")
            standardDefaults.synchronize()

            server.clearHistoryInfo("txt")
        }
        
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        var registerVC = storyBoard.instantiateViewControllerWithIdentifier("view") as! RegisViewController
        self.window?.rootViewController = registerVC

        
    }


}

