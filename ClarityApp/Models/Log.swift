//
//  Log.swift
//  ClarityApp
//
//  Created by Yaguang Ding on 2019/1/10.
//  Copyright © 2019 Yaguang Ding. All rights reserved.
//

import Foundation
import RealmSwift

`
class StatusLog : Object{
    @objc dynamic var status: String = ""
    @objc dynamic var appId: String = ""
    @objc dynamic var appName: String = ""
    @objc dynamic var appVersion: String = ""
    @objc dynamic var windowTitle: String = ""
    @objc dynamic var end: Int32 = 0
    @objc dynamic var start: Int32 = 0
    @objc dynamic var duration: Int32 = 0
}
