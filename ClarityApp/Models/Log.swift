//
//  Log.swift
//  ClarityApp
//
//  Created by Yaguang Ding on 2019/1/10.
//  Copyright © 2019 Yaguang Ding. All rights reserved.
//

import Foundation
import RealmSwift
import HandyJSON


class StatusLog : Object, HandyJSON, NSCopying{
    @objc dynamic var status: String = ""
    @objc dynamic var appId: String = ""
    @objc dynamic var appName: String = ""
    @objc dynamic var appVersion: String = ""
    @objc dynamic var windowTitle: String = ""
    @objc dynamic var end: Int32 = 0
    @objc dynamic var start: Int32 = 0
    @objc dynamic var duration: Int32 = 0
    
    override static func indexedProperties() -> [String] {
        return ["start"]
    }
    
    func copy(with: NSZone? = nil) -> Any {
        let newobj = StatusLog()
        newobj.status = self.status
        newobj.appId = self.appId
        newobj.appName = self.appName
        newobj.appVersion = self.appVersion
        newobj.windowTitle = self.windowTitle
        newobj.end = self.end
        newobj.start = self.start
        newobj.duration = self.duration
        return newobj
    }
}
