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
    var status      : String
    var appId       : String
    var appName     : String
    var appVersion  : String
    var windowTitle : String
    var idle        : Int32

    
    init () {
        self.status = "active"
        self.appId = ""
        self.appName = ""
        self.appVersion = ""
        self.windowTitle = ""
        self.idle = 0
    }
}

class TimeTracker {
    let IDLE_TIME = 60 * 5
    var lastLog : StatusLog?
    var permissionPrompt = true
    let realm = try! Realm()
    
    func inspect(app: NSRunningApplication?) -> SystemStatus? {
        var status : SystemStatus = SystemStatus()
        
        status.idle = Int32(SystemIdleTime() ?? 0)
        if(status.idle > IDLE_TIME) {
            status.status = "idle"
        }
        
        // Get the process ID of the frontmost application.
        if(app == nil) {
            app = NSWorkspace.shared.frontmostApplication
        }
        let pid = app!.processIdentifier
        
        status.appId = app?.bundleIdentifier ?? ""
        status.appName = app?.localizedName ?? ""
        if(status.appId == "com.apple.loginwindow") {
            status.status = "idle"
        }

        autoreleasepool {
            IconUtil.save(appId: status.appId, img: app!.icon!)
        }
        
        return status
        // -------- 暂时不搜集更多信息 ----------     
        // See if we have accessibility permissions, and if not, prompt the user to
        // visit System Preferences.
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() : permissionPrompt]
        let appHasPermission: Bool = AXIsProcessTrustedWithOptions(options as  CFDictionary?)
        
        // Only prompt once
        permissionPrompt = false
        
        // we don't have accessibility permissions
        if(!appHasPermission) {
            NSLog("has no permissions")
            return status
        }
        // Get the accessibility element corresponding to the frontmost application.
        let appElem = AXUIElementCreateApplication(pid)
        
        // Get the accessibility element corresponding to the frontmost window
        // of the frontmost application.
        var window: CFTypeRef?
        var err = AXUIElementCopyAttributeValue(appElem, kAXFocusedWindowAttribute as CFString, &window)
        if err != AXError.success {
            NSLog("get focused window error")
            return status
        }
        // print("window", window!)
        // Finally, get the title of the frontmost window.
        var title : CFTypeRef?
        err = AXUIElementCopyAttributeValue(window as! AXUIElement, kAXTitleAttribute as CFString, &title)
        if err != AXError.success {
            NSLog("get title error")
            return status
        }
        status.windowTitle = title as! String

        return status
    }
    
    func storeLog(_ log: StatusLog){
        try! realm.write {
            NSLog("write log %@ %@", log.status, log.appName)
            realm.add(log)
        }
    }
    
    func log(status : SystemStatus) {
        let timestampNow = Int32(Date().timeIntervalSince1970)
        if lastLog == nil || lastLog!.appId != status.appId || lastLog?.status != status.status {
            if lastLog != nil {
                lastLog!.end = timestampNow
                lastLog!.duration = lastLog!.end - lastLog!.start
                storeLog(lastLog!)
            }
            
            lastLog = StatusLog()
            lastLog?.status = status.status
            lastLog?.appId = status.appId
            lastLog?.appName = status.appName
            lastLog?.appVersion = status.appVersion
            lastLog?.windowTitle = status.windowTitle
            lastLog!.start = timestampNow
            return
        }
        lastLog?.end = timestampNow
        lastLog?.duration = lastLog!.end - lastLog!.start
    }
    
    @objc func printMe(notification: NSNotification) {
        let app = notification.userInfo!["NSWorkspaceApplicationKey"] as! NSRunningApplication
        print(app.localizedName!)
    }
    
    
    func run() {
        let delegate = NSApplication.shared.delegate as! AppDelegate
        print(realm.configuration.fileURL ?? "")
        
//        NSWorkspace.shared.notificationCenter.addObserver(self,
//          selector: #selector(printMe(notification:)),
//          name: NSWorkspace.didActivateApplicationNotification,
//          object:nil)

        while true {
            let status = inspect(app: nil)
            print(status?.appName)
            delegate.lastLog = lastLog?.copy() as! StatusLog?
            if(status != nil) {
                log(status: status!)
            }
            
            sleep(1)
        }
    }
}
