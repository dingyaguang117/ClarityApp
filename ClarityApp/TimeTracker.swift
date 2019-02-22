//
//  TimeTracker.swift
//  ClarityApp
//
//  Created by Yaguang Ding on 2019/1/10.
//  Copyright © 2019 Yaguang Ding. All rights reserved.
//
import AppKit
import Foundation
import RealmSwift


struct SystemStatus {
    var appId    : String
    var appName     : String
    var appVersion  : String
    var windowTitle : String
    var idle        : Int32

    
    init () {
        self.appId = ""
        self.appName = ""
        self.appVersion = ""
        self.windowTitle = ""
        self.idle = 0
    }
}

class TimeTracker {
    var lastLog : StatusLog?
    let realm = try! Realm()
    
    func inspect() -> SystemStatus? {
        var status : SystemStatus = SystemStatus()
        
        // Get the process ID of the frontmost application.
        let app = NSWorkspace.shared.frontmostApplication
        let pid = app!.processIdentifier
        
        status.appId = app?.bundleIdentifier ?? ""
        status.appName = app?.localizedName ?? ""

        // See if we have accessibility permissions, and if not, prompt the user to
        // visit System Preferences.
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() : true]
        let appHasPermission: Bool = AXIsProcessTrustedWithOptions(options as  CFDictionary?)
        
        // we don't have accessibility permissions
        if(!appHasPermission) {
            print("has no permissions")
            return status
        }
        // Get the accessibility element corresponding to the frontmost application.
        let appElem = AXUIElementCreateApplication(pid)
        
        // Get the accessibility element corresponding to the frontmost window
        // of the frontmost application.
        var window: CFTypeRef?
        var err = AXUIElementCopyAttributeValue(appElem, kAXFocusedWindowAttribute as CFString, &window)
        if err != AXError.success {
            print("get focused window error")
            return status
        }
        // print("window", window!)
        // Finally, get the title of the frontmost window.
        var title : CFTypeRef?
        err = AXUIElementCopyAttributeValue(window as! AXUIElement, kAXTitleAttribute as CFString, &title)
        if err != AXError.success {
            print("get title error")
            return status
        }
        status.windowTitle = title as! String

        return status
    }
    
    func storeLog(_ log: StatusLog){
        try! realm.write {
            print("write log")
            realm.add(log)
        }

    }
    
    func log(status : SystemStatus) {
        let timestampNow = Int32(Date().timeIntervalSince1970)
        if lastLog == nil || lastLog!.appId != status.appId {
            if lastLog != nil {
                lastLog!.end = timestampNow
                lastLog!.duration = lastLog!.end - lastLog!.start
                storeLog(lastLog!)
            }
            
            lastLog = StatusLog()
            lastLog?.appId = status.appId
            lastLog?.appName = status.appName
            lastLog?.appVersion = status.appVersion
            lastLog?.windowTitle = status.windowTitle
            lastLog!.start = timestampNow
            return
        }
    }
    
    func run() {
        print(realm.configuration.fileURL ?? "")
        while true {
            var status = inspect()
//            print(status)
            if(status != nil) {
                log(status: status!)
            }
            
            sleep(1)
        }
    }
}
