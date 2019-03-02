//
//  PopoverViewController.swift
//  ClarityApp
//
//  Created by Yaguang Ding on 2019/2/28.
//  Copyright © 2019 Yaguang Ding. All rights reserved.
//

import Cocoa
import RealmSwift

class PopoverViewController: NSViewController {
    
    var stats : [StatsItem]?
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        print("================= load table view")
    }
}

// MARK: 请求数据

struct StatsItem {
    var appId : String
    var appName : String
    var count : Int32
    var time :  Int32
    
    func timeString() -> String {
        var time = self.time
        var result = ""
        
        if(self.time > 3600) {
            result += String(format: "%dh", arguments: [time / 3600])
            time %= 3600
        }
        if(self.time > 60) {
            result += String(format: " %dm", arguments: [time / 60])
            time %= 60
        }
        if(time > 0) {
            result += String(format: " %ds", arguments: [time])
        }
        
        return result
    }
}


extension Results {
    func toArray<T>(type: T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
}


extension PopoverViewController {
    func refresh() {
        self.loadStats()
        if(self.tableView != nil) {
            self.tableView.reloadData()
        }
        
    }
    
    func loadStats() {
        stats = [StatsItem]()
        
        let realm = try! Realm()
        
        let timeToday = Date(timeIntervalSinceNow: -86400)
        var statusLogs = realm.objects(StatusLog.self).filter("start > %@", Int(timeToday.timeIntervalSince1970)).toArray(type: StatusLog.self)
        // TODO: calc lastLog
        //        let app = NSApplication.shared.delegate as! AppDelegate
//        if(app.lastLog != nil) {
//            statusLogs.append(app.lastLog!)
//        }
//
        
        
        var dict = [String: StatsItem]()
        for i in 0..<statusLogs.count {
            let log = statusLogs[i]
            if !dict.keys.contains(log.appName) {
                dict[log.appName] = StatsItem(appId: log.appId, appName: log.appName, count: 0, time: 0)
            }
            dict[log.appName]!.time += log.duration
            dict[log.appName]!.count += 1
        }
 
        for item in dict.sorted(by: {$0.1.time > $1.1.time}) {
            stats?.append(item.value)
        }
    
    }
    
}


// 配置tableView

extension PopoverViewController : NSTableViewDataSource, NSTableViewDelegate{
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .clear
        self.tableView.headerView = nil
        self.tableView.enclosingScrollView?.drawsBackground = false
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return true
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        NSLog("number %@", tableView)
        return min(stats!.count, 10) ;
    }
    
    fileprivate enum CellIdentifiers {
        static let IconNameCell = "IconNameCellID"
        static let TimeCell = "TimeCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var statsItem = stats![row]
        var image = NSImage(named: "monitor")
        var text: String = ""
        var cellIdentifier: String = ""

        if tableColumn == tableView.tableColumns[0] {
            text = statsItem.appName
            image = IconUtil.load(appId: statsItem.appId)
            cellIdentifier = CellIdentifiers.IconNameCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = String(statsItem.timeString())
            cellIdentifier = CellIdentifiers.TimeCell
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            cell.imageView?.image = image ?? nil
            return cell
        }
        return nil
    }
}

