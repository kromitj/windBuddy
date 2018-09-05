//
//  CalculationTableViewController.swift
//  WindBuddy
//
//  Created by Mitch Kroska on 9/4/18.
//  Copyright © 2018 Mitch Kroska. All rights reserved.
//

import Cocoa

class CalculationTableViewController: NSObject {
    @IBOutlet weak var tableView: NSTableView!
    var data: [TableCell]
    override init() {        
        data = []
        super.init()
        
    }
}
