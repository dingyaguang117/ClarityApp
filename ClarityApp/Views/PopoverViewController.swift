//
//  PopoverViewController.swift
//  ClarityApp
//
//  Created by Yaguang Ding on 2019/2/28.
//  Copyright © 2019 Yaguang Ding. All rights reserved.
//

import Cocoa

class PopoverViewController: NSViewController {
    
 
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .clear

    }
    
}


// MARK: 请求数据

extension PopoverViewController : NSTableViewDataSource, NSTableViewDelegate{
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        NSLog("number %@", tableView)
        return 5;
    }
    
    fileprivate enum CellIdentifiers {
        static let IconNameCell = "IconNameCellID"
        static let TimeCell = "TimeCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var image = NSImage(named: "monitor")
        var text: String = ""
        var cellIdentifier: String = ""

        // 2
        if tableColumn == tableView.tableColumns[0] {

            text = "QQ"
            cellIdentifier = CellIdentifiers.IconNameCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = "1h 22min"
            cellIdentifier = CellIdentifiers.TimeCell
        }
        
        // 3
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            cell.imageView?.image = image ?? nil
            return cell
        }
        return nil
    }
}

