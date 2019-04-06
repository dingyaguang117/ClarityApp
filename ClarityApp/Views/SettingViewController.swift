//
//  ViewController.swift
//  ClarityApp
//
//  Created by Yaguang Ding on 2019/1/10.
//  Copyright © 2019 Yaguang Ding. All rights reserved.
//

import Cocoa
import ServiceManagement
import AppKit

class SettingViewController: NSViewController {
    @IBOutlet weak var startAtLogin: NSButton!
    
    @IBOutlet weak var versionLabel: NSTextField!
    
    @IBAction func checkUpdate(_ sender: Any) {
        let delegate = NSApplication.shared.delegate as! AppDelegate
        delegate.Updater.checkForUpdates(nil)
    }
    
    @IBAction func startAtLoginChanged(_ sender: NSButton) {
        if sender.state == .on {
            print("start auto start ")
            LauncherHelper.shared.launchAtStartup = true
        }else {
            print("stop auto start ")
            LauncherHelper.shared.launchAtStartup = false
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.startAtLogin.state = LauncherHelper.shared.launchAtStartup ? .on : .off
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        if(appVersion != nil) {
            versionLabel.stringValue = "Clarity " + appVersion!
        }
        
    }

}

