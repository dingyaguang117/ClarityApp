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
    
    @IBAction func startAtLoginChanged(_ sender: NSButton) {
        if sender.state == .on {
            LauncherHelper.shared.launchAtStartup = true
        }else {
            LauncherHelper.shared.launchAtStartup = false
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.startAtLogin.state = LauncherHelper.shared.launchAtStartup ? .on : .off
    }

}

