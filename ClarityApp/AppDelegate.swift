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
import Sparkle

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    

    @IBOutlet weak var Updater: SUUpdater!
    @IBOutlet var statusMenu: NSMenu?;
    var statusItem: NSStatusItem?;
    let popover = NSPopover()
    let popoverController = PopoverViewController()
    public var lastLog: StatusLog?
    


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupStatusBar()
        setupPopover()
        setupLauncher()
        
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

}


// For LaunchAtStartup

extension AppDelegate {
    

    func setupLauncher() {
        LauncherHelper.shared.launchAtStartup = true
        statusMenu?.item(withTag: 2)?.state = .on
        
        for app in NSWorkspace.shared.runningApplications {
            if app.bundleIdentifier == LauncherHelper.Identifier    {
                let notification = Notification.Name("killme");
                DistributedNotificationCenter.default().post(name: notification, object: Bundle.main.bundleIdentifier!);
                break;
            }
        }
    }

}


// For StatusBar and StatusMenu

extension AppDelegate {
  
    func setupStatusBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let image = NSImage (named: "monitor")
        image?.isTemplate = true
        //statusItem?.menu = statusMenu
        statusItem?.button?.image = image
        statusItem?.button?.action = #selector(OpenPopover(_:))
    }
    
    
    @IBAction func launchAtStartupChange(_ sender: NSMenuItem) {
        if sender.state == .on {
            LauncherHelper.shared.launchAtStartup = false
            sender.state = .off
        }else {
            LauncherHelper.shared.launchAtStartup = true
            sender.state = .on
        }
    }
    
    @IBAction func menuClickQuit(_ sender: Any) {
        NSApplication.shared.terminate(nil)
    }
}


// =MARK Popover

extension AppDelegate {
    
    func setupPopover() {
        popover.contentViewController = self.popoverController
        popover.behavior = .transient
        //popover.appearance = NSAppearance(appearanceNamed: .darkAqua, bundle: nil)
    }
    
    @IBAction func OpenPopover(_ sender: NSMenuItem) {
        let button = statusItem!.button
        popoverController.refresh()
        popover.show(relativeTo: button!.bounds, of: button!, preferredEdge: NSRectEdge.minY)
    }
    
}
