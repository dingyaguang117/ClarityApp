//
//  TimeTracker.swift
//  ClarityApp
//
//  Created by Yaguang Ding on 2019/1/10.
//  Copyright © 2019 Yaguang Ding. All rights reserved.
//
import AppKit
import Foundation

struct SystemStatus {
    var bundleId    : String?
    var appName     : String?
    var appVersion  : String?
    var windowTitle : String?
    var idle        : Int?
    var osUsername  : String?
    var machineName : String?
}

class TimeTracker {
    func inspect() -> SystemStatus? {
        var status : SystemStatus = SystemStatus()
        
        // Get the process ID of the frontmost application.
        let app = NSWorkspace.shared.frontmostApplication
        let pid = app!.processIdentifier
        
        status.bundleId = app?.bundleIdentifier
        status.appName = app?.localizedName

        // See if we have accessibility permissions, and if not, prompt the user to
        // visit System Preferences.
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() : true]
        let appHasPermission: Bool = AXIsProcessTrustedWithOptions(options as  CFDictionary?)
        
        // we don't have accessibility permissions
        if(!appHasPermission) {
            print("has no permissions")
            return nil
        }
        // Get the accessibility element corresponding to the frontmost application.
        let appElem = AXUIElementCreateApplication(pid)
        
        // Get the accessibility element corresponding to the frontmost window
        // of the frontmost application.
        var window: CFTypeRef?
        var err = AXUIElementCopyAttributeValue(appElem, kAXFocusedWindowAttribute as CFString, &window)
        if err != AXError.success {
            print("get focused window error")
            return nil
        }
        print("window", window!)
        // Finally, get the title of the frontmost window.
        var title : CFTypeRef?
        err = AXUIElementCopyAttributeValue(window as! AXUIElement, kAXTitleAttribute as CFString, &title)
        if err != AXError.success {
            print("get title error")
            return nil
        }
        status.windowTitle = title as! String

        return status
    }
    
    func run() {
        while true {
            var status = inspect()
            print(status)
            sleep(1)
        }
    }
}
