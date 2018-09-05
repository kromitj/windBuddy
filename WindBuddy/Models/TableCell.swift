//
//  TableCell.swift
//  WindBuddy
//
//  Created by Mitch Kroska on 9/4/18.
//  Copyright © 2018 Mitch Kroska. All rights reserved.
//

import Cocoa

class TableCell: NSObject {
    var property: String
    var value: String
    init(prop: String, val: String) {
        property = prop
        value = val
        super.init()
    }
}
