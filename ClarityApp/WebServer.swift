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
import Foundation


class Server {
    let server : HttpServer
    let delegate = NSApplication.shared.delegate as! AppDelegate
    
    init() {
        self.server = HttpServer()
        self.server["/status"] = { request in
            var query = Dictionary<String, String>(uniqueKeysWithValues: request.queryParams)
            let start = query["start"]
            let end = query["end"]
            var data = [Any]()
            autoreleasepool {
                let realm = try! Realm()
                realm.refresh()
                
                let startTime = Int(start ?? "0")
                if startTime != nil {
                    let items = realm.objects(StatusLog.self).filter("start >= %@", startTime as Any)
                    for item in items {
                        data.append(item.toJSON() as Any)
                    }
                }
            }
            let result: [String : Any] = ["code": 0, "data": data]
            let rawResult = try! JSONSerialization.data(withJSONObject: result)
            return HttpResponse.raw(200, "OK", self.headers(), { writer in try writer.write(rawResult)})
        }
        
        self.server["/hello"] = {
            request in
            return HttpResponse.raw(200, "OK", self.headers(), { writer in try writer.write([UInt8]("clarity".utf8))})
        }
        
        self.server["/status-now"] = {
            request in
            let result: [String : Any] = ["code": 0, "data": self.delegate.lastLog?.toJSON()]
            let rawResult = try! JSONSerialization.data(withJSONObject: result)
            return HttpResponse.raw(200, "OK", self.headers(), { writer in try writer.write(rawResult)})
        }
        
        
        self.server["/icon/:path"] = shareFilesFromDirectory(IconUtil.iconDirectory().path)
        
//        self.server["/icon/:path"] = { r in
//            guard let fileRelativePath = r.params.first else {
//                return .notFound
//            }
//
//            if let file = try? (IconUtil.iconDirectory().path + String.pathSeparator + fileRelativePath.value + ".png").openForReading() {
//                let mimeType = fileRelativePath.value.mimeType();
//                return .raw(200, "OK", ["Content-Type": mimeType], { writer in
//                    try? writer.write(file)
//                    file.close()
//                })
//            }
//            return .notFound
//        }
    }
    
    func headers() ->  [String: String] {
        return [
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "GET, POST, PUT",
            "Access-Control-Allow-Headers": "DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization",
        ]
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

