//
//  WebServer.swift
//  ClarityApp
//
//  Created by Yaguang Ding on 2019/1/10.
//  Copyright © 2019 Yaguang Ding. All rights reserved.
//

import Swifter
import Dispatch

class Server {
    let server : HttpServer
    
    init() {
        self.server = HttpServer()
        self.server["/status"] = { request in
            var data: [String : Any] = ["code": 0, "data": []]
            return HttpResponse.ok(.json(data as AnyObject))
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

