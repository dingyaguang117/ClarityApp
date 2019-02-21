//
//  AppDelegate.swift
//  ClarityApp
//
//  Created by Yaguang Ding on 2019/1/10.
//  Copyright © 2019 Yaguang Ding. All rights reserved.
//

import AppKit
import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet var statusMenu: NSMenu?;
    var statusItem: NSStatusItem?;
    let launchHelperIdentifier = "com.co-ding.ClarityLauncherHelper"
    var launchAtStartup: Bool {
        get {
            let jobs = SMCopyAllJobDictionaries(kSMDomainUserLaunchd).takeRetainedValue() as? [[String: AnyObject]]
            for job in jobs! {
                //  print(job)
            }
            return jobs?.contains(where: { $0["Label"] as! String == launchHelperIdentifier }) ?? false
        }
        set {
            print("set launchAtStartup", newValue)
            SMLoginItemSetEnabled(launchHelperIdentifier as CFString, newValue)
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



// For LaunchAtStartup

extension AppDelegate {
    
    func setupLauncher() {
        
        launchAtStartup = true
        statusMenu?.item(withTag: 2)?.state = .on
        
        for app in NSWorkspace.shared.runningApplications {
            if app.bundleIdentifier == launchHelperIdentifier    {
                let notification = Notification.Name("killme");
                DistributedNotificationCenter.default().post(name: notification, object: Bundle.main.bundleIdentifier!);
                break;
            }
        }
    }

}


// For StatusBar and StatusMenu

extension AppDelegate {
  
    func addStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let image = NSImage (named: "monitor")
        image?.isTemplate = true
        statusItem?.menu = statusMenu
        statusItem?.button?.image = image
    }
    
    
    @IBAction func launchAtStartupChange(_ sender: NSMenuItem) {
        if sender.state == .on {
            launchAtStartup = false
            sender.state = .off
        }else {
            launchAtStartup = true
            sender.state = .on
        }
    }
    
    @IBAction func menuClickQuit(_ sender: Any) {
        NSApplication.shared.terminate(nil)
    }
    
}
