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

class ViewController: NSViewController {
    
    @IBOutlet weak var startAtLogin: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("window loaded")
        
        let appdel : AppDelegate = NSApplication.shared.delegate as! AppDelegate;
        self.startAtLogin.title = String(appdel.launchAtStartup);
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

