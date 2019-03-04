//
//  LauncherHelper.swift
//  ClarityApp
//
//  Created by Yaguang Ding on 2019/3/4.
//  Copyright © 2019 Yaguang Ding. All rights reserved.
//

import Foundation
import ServiceManagement

class LauncherHelper {
    
    static let shared = LauncherHelper()
    static let Identifier = "com.co-ding.ClarityLauncherHelper"
    
    var launchAtStartup: Bool {
        get {
            let jobs = SMCopyAllJobDictionaries(kSMDomainUserLaunchd).takeRetainedValue() as? [[String: AnyObject]]

            return jobs?.contains(where: { $0["Label"] as! String == LauncherHelper.Identifier }) ?? false
        }
        set {
            print("set launchAtStartup", newValue)
            SMLoginItemSetEnabled(LauncherHelper.Identifier as CFString, newValue)
        }
    }
    

}
