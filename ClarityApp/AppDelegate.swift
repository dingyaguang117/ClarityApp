//
//  AppDelegate.swift
//  ClarityApp
//
//  Created by Yaguang Ding on 2019/1/10.
//  Copyright © 2019 Yaguang Ding. All rights reserved.
//

import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func setupLauncher() {
        let appId = "com.co-ding.ClarityLauncherHelper";
        SMLoginItemSetEnabled(appId as CFString, true);
        
        var startedAtLogin = false
        
        for app in NSWorkspace.shared.runningApplications {
            if app.bundleIdentifier == appId    {
                
                startedAtLogin = true;
            }
        }
        if startedAtLogin {
            let notification = Notification.Name("killme");
            DistributedNotificationCenter.default().post(name: notification, object: Bundle.main.bundleIdentifier!);
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        setupLauncher()
        
        // Insert code here to initialize your application
        let queue = DispatchQueue(label: "com.co-ding.clarityapp", qos: .unspecified, attributes: .concurrent)
        queue.async {
            let timeTracker = TimeTracker()
            //timeTracker.run()
        }
        queue.async {
            let server = Server()
            server.run(port: 9877)
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

