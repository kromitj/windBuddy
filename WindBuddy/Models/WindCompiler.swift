//  WindCompiler.swift
//  ORSSerialPortDemo
//
//  Created by Mitch Kroska on 8/6/18.
//  Copyright © 2018 Open Reel Software. All rights reserved.
//

import Foundation
var totalCount = 0

class WindCompiler {
    var rotationsPerRow: Float = 0.0
    var stepsPerRow: Float = 0.0
    var stepsPerInterval: Float = 0.0
    var dispersedStepsPerInterval: [Int] = []
    var maxWindsPerRow: Float = 0.0
    var maxWindsAtRowInterval: Float = 0.0
    var mappedPattern: [[Int]] = [[]]
    
    init() {
        
    }
    
    init(windCount: Int, bobbinHeight: Float,wireWidth: Float,screwPitch: Int,stepperResolution: Int, intervals: Int, windPattern: [[Int]]) {
        self.rotationsPerRow = calcRotationsPerRow(bobbinHeight: bobbinHeight, screwPitch: screwPitch)
        self.stepsPerRow = calcStepsPerRow(rotationsPerRow: rotationsPerRow, stepperResolution: stepperResolution)
        self.stepsPerInterval = calcStepsPerInterval(stepsPerRow: stepsPerRow, intervals: intervals)
        self.dispersedStepsPerInterval = disperseStepsPerInterval(intervals: intervals, stepsPerRow: Int(stepsPerRow))
        self.maxWindsPerRow = calcMaxWinds(bobbinHeight: bobbinHeight, wireWidth: wireWidth)
        self.maxWindsAtRowInterval = maxWindsPerRow/Float(intervals)
        self.mappedPattern = mapPatternwithSteps(windPattern: windPattern, maxWindsAtInterval: maxWindsAtRowInterval, stepsPerInterval: stepsPerInterval)
        print(totalCount)
        
    }
    
    private func calcMaxWinds(bobbinHeight: Float, wireWidth: Float) -> Float {
        return bobbinHeight/wireWidth
    }
    
    private func calcRotationsPerRow(bobbinHeight: Float, screwPitch: Int) -> Float {
        return bobbinHeight/Float(screwPitch)
    }
    
    private func calcStepsPerRow(rotationsPerRow: Float, stepperResolution: Int) -> Float {
        return ceil(rotationsPerRow * Float(stepperResolution))
    }
    
    private func calcStepsPerInterval(stepsPerRow: Float, intervals: Int) -> Float {
        return stepsPerRow/Float(intervals)
    }
    
    private func disperseStepsPerInterval(intervals: Int, stepsPerRow: Int) -> [Int] {
        var remainder: Float = 0.0
        var dispersedSPI: [Int] = []
        var total: Float = 0.0
        let StepsPerInterval: Float = Float(stepsPerRow)/Float(intervals)
        let FlooredStepsPerInterval = Int(StepsPerInterval)
        let intervalRemainder: Float = StepsPerInterval-Float(FlooredStepsPerInterval)
        for n in (0...intervals-1) {
            remainder += intervalRemainder
            total += Float(FlooredStepsPerInterval)
            dispersedSPI.append(FlooredStepsPerInterval)
            if (remainder >= 1.0) {
                dispersedSPI[n] += 1
                remainder -= 1
                total += 1
            }
        }
        if (remainder >= 0.5) {
            dispersedSPI[intervals-1] += 1
            total += 1
        }
        return dispersedSPI
    }
    
    private func mapPatternwithSteps(windPattern: [[Int]], maxWindsAtInterval: Float, stepsPerInterval: Float) -> [[Int]] {
        var mappedWindPatttern: [[Int]] = Array(repeating: Array(repeating: 0, count: 0), count: windPattern.count)
        
        for (i, row) in windPattern.enumerated() {
            var remainder: Float = 0.0
            for (j, interval) in (row.enumerated()) {
                print(interval)
                var windsAtInterval = (Float(interval)/100.0)*maxWindsAtInterval
                let windsAtIntervalRounded = windsAtInterval.rounded()
                remainder += (windsAtInterval - windsAtIntervalRounded)
                if remainder > 1 {
                    windsAtInterval += 1
                    remainder = 0
                    print("windsAtInterval += 1")
                }
                if remainder < -1 {
                    windsAtInterval -= 1
                    print("windsAtInterval -= 1")
                    remainder = 0
                }
                let stepsPerWind = Float(dispersedStepsPerInterval[j])/windsAtInterval
                mappedWindPatttern[i] = mappedWindPatttern[i] + evenlyDistributeStepsForInterval(windsAtInterval: windsAtInterval, stepsPerInterval: Float(dispersedStepsPerInterval[j]))
                
                //              print(mappedWindPatttern)
            }
        }
        totalCount = 0
        return mappedWindPatttern
    }
    
    private func evenlyDistributeStepsForInterval(windsAtInterval: Float, stepsPerInterval: Float) -> [Int] {
        var remainder: Float = 0.0
        var count = 0
        var evenlyDistibutedSteps: [Int] = []
        let roundedWindsAtInterval = (windsAtInterval).rounded()
        let stepsPerWind = stepsPerInterval/roundedWindsAtInterval
        
        for n in (0...Int(roundedWindsAtInterval)-1) {
            let flooredStepsPerWind = Int(stepsPerWind.rounded())
            let stepRemainder =  stepsPerWind - Float(flooredStepsPerWind)
            remainder += stepRemainder
            evenlyDistibutedSteps.append(flooredStepsPerWind)
            count += flooredStepsPerWind
            totalCount += flooredStepsPerWind
            if (remainder >= 1.0 && count <= Int(stepsPerInterval)) {
                evenlyDistibutedSteps[n] += 1
                remainder -= 1
                count += 1
                totalCount += 1
            } else if (remainder <= -1.0) {
                evenlyDistibutedSteps[n] -= 1
                remainder += 1
                count -= 1
                totalCount -= 1
            }
        }
        
        if (remainder > 0.5) {
            count += 1
            totalCount += 1
            //            print("--------remainer added to end")
            evenlyDistibutedSteps[Int(roundedWindsAtInterval)-1] += 1
        } else if (remainder < -0.5) {
            count -= 1
            totalCount -= 1
            //            print("--------remainer subtracted to end")
            evenlyDistibutedSteps[Int(roundedWindsAtInterval)-1] -= 1
        }
        if (Float(totalCount) < stepsPerInterval) {
            //            print("Added becuase below: ", stepsPerRow)
            evenlyDistibutedSteps[Int(roundedWindsAtInterval)-1] += 1
            count += 1
            totalCount += 1
        }
        //        if (Float(totalCount) > stepsPerInterval+1) {
        //            print("Sub cuz above: ", stepsPerRow)
        //            evenlyDistibutedSteps[Int(roundedWindsAtInterval)-1] -= 1
        //            count -= 1
        //            totalCount -= 1
        //        }
        print("Count: ",  count, ", Steps per Interval: ", stepsPerInterval)
        print(evenlyDistibutedSteps)
        return evenlyDistibutedSteps
    }
    
    func toSring() -> String {
        var windPatternString = ""
        for (_, row) in self.mappedPattern.enumerated() {
            var windPatternRow = ""
            for (_, cell) in row.enumerated() {
                let u = UnicodeScalar(cell+97)
                windPatternRow += String(Character(u!))
            }
            print(windPatternRow)
            windPatternRow += "-"
            
            windPatternString += windPatternRow
        }
                print("Total: ", totalStepsPerRow())
        return windPatternString
    }
    
    func totalStepsPerRow() {
        for row in mappedPattern {
            var stepCount = 0
            for interval in row {
                stepCount += interval
            }
            print ("RowCount: ", stepCount, "stepsPerRow: ", self.stepsPerRow, "equality: ", (stepCount == Int(self.stepsPerRow)))
        }
    }
    
    
}
