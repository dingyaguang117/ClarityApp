//
//  IconUtil.swift
//  ClarityApp
//
//  Created by Yaguang Ding on 2019/3/1.
//  Copyright © 2019 Yaguang Ding. All rights reserved.
//
import AppKit
import Foundation

extension NSBitmapImageRep {
    var png: Data? {
        return representation(using: .png, properties: [:])
    }
}
extension Data {
    var bitmap: NSBitmapImageRep? {
        return NSBitmapImageRep(data: self)
    }
}
extension NSImage {
    var png: Data? {
        return tiffRepresentation?.bitmap?.png
    }
    func savePNG(to url: URL) -> Bool {
        do {
            try png?.write(to: url)
            return true
        } catch {
            print(error)
            return false
        }
        
    }
}

class IconUtil {
    public static func save(appId: String, img: NSImage) -> String{
        let filename = appId + ".png"
        let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appendingPathComponent(Bundle.main.bundleIdentifier!).appendingPathComponent("icons")
        let fullpath = path.appendingPathComponent(filename)
        if(FileManager.default.fileExists(atPath: fullpath.path)) {
            return fullpath.path
        }
        
        try! FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
        
        if img.savePNG(to: fullpath) {
            print("image saved as PNG")
        }
        return fullpath.path
    }
    
    
    static func load(appId: String) -> NSImage? {
        let filename = appId + ".png"
        let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appendingPathComponent(Bundle.main.bundleIdentifier!).appendingPathComponent("icons")
        let fullpath = path.appendingPathComponent(filename)
        
        
        return NSImage(contentsOf: fullpath)
    }

}


