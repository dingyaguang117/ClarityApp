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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appdel : AppDelegate = NSApplication.shared.delegate as! AppDelegate;
        self.startAtLogin.state = appdel.launchAtStartup ? .on : .off
    }

}

