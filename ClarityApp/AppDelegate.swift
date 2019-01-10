//
//  AppDelegate.swift
//  ClarityApp
//
//  Created by Yaguang Ding on 2019/1/10.
//  Copyright © 2019 Yaguang Ding. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let queue = DispatchQueue(label: "com.co-ding.clarityapp", qos: .unspecified, attributes: .concurrent)
        queue.async {
            let timeTracker = TimeTracker()
            timeTracker.run()
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

