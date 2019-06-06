//
//  AppDelegate.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/12.
//  Copyright © 2019 周巍然. All rights reserved.
//

import UIKit

let activityIndicator: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView()
    spinner.hidesWhenStopped = true
    spinner.bounds = CGRect(origin: .zero, size: CGSize(width: 20, height: 20))
    spinner.translatesAutoresizingMaskIntoConstraints = false
    return spinner
}()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        YoutubeManager.shared.doInitialRequest()
        screenWidth = UIScreen.main.nativeBounds.width / UIScreen.main.nativeScale
        screenHeight = UIScreen.main.nativeBounds.height / UIScreen.main.nativeScale
        scaleFactor = UIScreen.main.nativeScale
        fullScreenScale = screenWidth / watchingHeight
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSString *fileName =[NSString stringWithFormat:@"%@.log",[NSDate date]];
//        NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
        
//        let logFilePath = ""
//        freopen(<#T##UnsafePointer<Int8>!#>, <#T##UnsafePointer<Int8>!#>, <#T##UnsafeMutablePointer<FILE>!#>)
//        freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
        
        window?.addSubview(activityIndicator)
        NSLayoutConstraint.activate([NSLayoutConstraint(item: window, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0),
                                     NSLayoutConstraint(item: window, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)])
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

