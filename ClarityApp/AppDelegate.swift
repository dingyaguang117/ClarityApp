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
    
    
    var statusItem: NSStatusItem?;
    let launchHelperIdentifier = "com.co-ding.ClarityLauncherHelper1"
    
    func addStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let image = NSImage (named: "monitor")
        image?.isTemplate = true
        statusItem?.button?.image = image
    }
    
    var launchAtStartup: Bool {
        get {
            let jobs = SMCopyAllJobDictionaries(kSMDomainUserLaunchd).takeRetainedValue() as? [[String: AnyObject]]
            for job in jobs! {
                print(job)
            }
            return jobs?.contains(where: { $0["Label"] as! String == launchHelperIdentifier }) ?? false
        }
        set {
            SMLoginItemSetEnabled(launchHelperIdentifier as CFString, newValue)
        }
    }
    
    func setupLauncher() {
        
        //let suc = SMLoginItemSetEnabled(launchHelperIdentifier as CFString, true);
        //print("success:", suc)
        print("success2:", launchAtStartup)
    
        
        for app in NSWorkspace.shared.runningApplications {
            if app.bundleIdentifier == launchHelperIdentifier    {
                let notification = Notification.Name("killme");
                DistributedNotificationCenter.default().post(name: notification, object: Bundle.main.bundleIdentifier!);
                break;
            }
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        addStatusItem()
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

