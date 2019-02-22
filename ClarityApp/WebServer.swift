//
//  WebServer.swift
//  ClarityApp
//
//  Created by Yaguang Ding on 2019/1/10.
//  Copyright © 2019 Yaguang Ding. All rights reserved.
//

import Swifter
import Dispatch
import RealmSwift

class Server {
    let server : HttpServer
    
    init() {
        self.server = HttpServer()
        self.server["/status"] = { request in
            var query = Dictionary<String, String>(uniqueKeysWithValues: request.queryParams)
            let start = query["start"]
            let end = query["end"]
            var data = [Any]()
            
            let realm = try! Realm()
            realm.refresh()
            
            var startTime = Int(start ?? "0")
            if startTime != nil {
                var items = realm.objects(StatusLog.self).filter("start >= %@", startTime)
                for item in items {
                    data.append(item.toJSON())
                }
            }
            var result: [String : Any] = ["code": 0, "data": data]
            return HttpResponse.ok(.json(result as AnyObject))
        }
    }
    
    
    func run(port: Int32) {
        let semaphore = DispatchSemaphore(value: 0)
        do {
            print("try start")
            try self.server.start(in_port_t(port))
            print("Server has started ( port = \(try server.port()) ). Try to connect now...")
            semaphore.wait()
        }
        catch {
            print("Server start error: \(error)")
            semaphore.signal()
        }
    }
}

