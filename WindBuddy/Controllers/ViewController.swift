//
//  ViewController.swift
//  WindBuddy
//
//  Created by Mitch Kroska on 8/23/18.
//  Copyright © 2018 Mitch Kroska. All rights reserved.
//

import Cocoa
import ORSSerial
protocol WindowControllerDelegate{
    func didCompile()
}

class ViewController: NSViewController  {
   var windowDelegate: WindowControllerDelegate?
    var wind = Wind()
    let windcalc = ["winds per row", "rotations per row"]    
    @objc dynamic var calcData: [TableCell] = []
    
    @IBOutlet weak var wireThickness: NSTextField!
    @IBOutlet weak var bobbinHeight: NSTextField!
    @IBOutlet weak var windCount: NSTextField!
    @IBOutlet weak var windDirection: NSSegmentedControl!
    @IBOutlet weak var intervals: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func compileWind(_ sender: Any) {
        wind.bobbinHieght = Float(self.bobbinHeight.stringValue)!
        wind.wireGauge = Float(self.wireThickness.stringValue)!
        wind.windings = self.windCount.integerValue
        wind.intervals = self.intervals.integerValue
        wind.windDirection = self.windDirection.integerValue
        wind.compileWind()
        windowDelegate?.didCompile()
        
        
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}
extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return windcalc.count
    }
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return windcalc[row]
    }
}

