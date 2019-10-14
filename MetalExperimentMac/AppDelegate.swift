//
//  AppDelegate.swift
//  MetalExperimentMac
//
//  Created by Peter Tang on 14/10/2019.
//  Copyright © 2019 Peter Tang. All rights reserved.
//

#if os(OSX)
import Cocoa
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        debugPrint(#function, "Starting Cocoa NSApplicationMain")
    }
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}
#else
import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        debugPrint(#function, "Starting UIKit UIApplicationMain")
    }
}
#endif



