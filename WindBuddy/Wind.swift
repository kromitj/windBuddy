

//
//  Wind.swift
//  ORSSerialPortDemo
//
//  Created by Mitch Kroska on 7/31/18.
//  Copyright © 2018 BugzyBonez Software. All rights reserved.
//

import Foundation

class Wind {
    var windings: Int = 8000
    var bobbinHieght: Float = 11.43
    var bobbinWidth: Float = 0.0
    var bobbinLength: Float = 0.0
    var wireGauge: Float =  0.06355
    var wireResistance: Float = 0.0
    var windDirection: Int = 0
    var intervals: Int = 10
    var windPattern: [Int] = []
    var isCompiled: Bool = false
    var windCompiler: WindCompiler = WindCompiler.init()
    
    
    
    func compileWind() {
        let compiledWind = WindCompiler.init(windCount: self.windings, bobbinHeight: self.bobbinHieght, wireWidth: self.wireGauge, screwPitch: 5, stepperResolution: 400, intervals: self.intervals, windPattern: [[100,83,73,62,50,39,56,67,78,81],[81,78,67,56,39,50,62,73,83,100],[83,73,62,50,39,56,67,78,81,100],[100,81,78,67,56,39,50,62,73,83],[73,62,50,39,56,67,78,81,100,83],[83,100,81,78,67,56,39,50,62,73], [62,50,39,56,67,78,81,100,83,73],[73,83,100,81,78,67,56,39,50,62],[50,39,56,67,78,81,100,83,73,62],[62,73,83,100,81,78,67,56,39,50],[39,56,67,78,81,100,83,73,62, 50],[50,62,73,83,100,81,78,67,56,39],[56,67,78,81,100,83,73,62, 50,39],[39,50,62,73,83,100,81,78,67,56],[67,78,81,100,83,73,62, 50,39,56],[56,39,50,62,73,83,100,81,78,67],[78,81,100,83,73,62, 50,39,56, 67], [67,56,39,50,62,73,83,100,81,78],[81,100,83,73,62, 50,39,56, 67,78],[78,67,56,39,50,62,73,83,100,81]])
        self.windCompiler = compiledWind
        
    }
    func packPacketForSerial() -> String {
       let windPatternStr = self.windCompiler.toSring()
        var packet = "$ISET+" + String(self.windings) + "+" + String(self.windDirection) + "+" + windPatternStr + "+"
        return packet
    }
    
}
