////
////  WindController.swift
////  WindBuddy
////
////  Created by Mitch Kroska on 8/24/18.
////  Copyright © 2018 Mitch Kroska. All rights reserved.
////
//
//import Foundation
//import ORSSerial
//
//class WindController: NSObject, ORSSerialPortDelegate, NSUserNotificationCenterDelegate {
//    func serialPortWasRemoved(fromSystem serialPort: ORSSerialPort) {
//        
//    }
//    
//    @objc let serialPortManager = ORSSerialPortManager.shared()
//    @objc let availableBaudRates = [300, 1200, 2400, 4800, 9600, 14400, 19200, 28800, 38400, 57600, 115200, 230400]
//    
//    @objc dynamic var serialPort: ORSSerialPort? {
//        didSet {
//            oldValue?.close()
//            oldValue?.delegate = nil
//            serialPort?.delegate = self
//        }
//    }
//    
//    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
//        self.openCloseButton.title = "Close"
//        let descriptor = ORSSerialPacketDescriptor(prefixString: "!pos", suffixString: ";", maximumPacketLength: 8, userInfo: nil)
//        serialPort.startListeningForPackets(matching: descriptor)
//    }
//    
//    func serialPortWasClosed(_ serialPort: ORSSerialPort) {
//        self.openCloseButton.title = "Open"
//    }
//    
//    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
//        if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
//            self.receivedDataTextView.textStorage?.mutableString.append(string as String)
//            self.receivedDataTextView.needsDisplay = true
//        }
//    }
//    
//    func serialPortWasRemoved(fromSystem serialPort: ORSSerialPort) {
//        self.serialPort = nil
//        self.openCloseButton.title = "Open"
//    }
//    
//    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
//        print("SerialPort \(serialPort) encountered an error: \(error)")
//    }
//    
//    // MARK: - NSUserNotifcationCenterDelegate
//    
//    func userNotificationCenter(_ center: NSUserNotificationCenter, didDeliver notification: NSUserNotification) {
//        let popTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//        DispatchQueue.main.asyncAfter(deadline: popTime) { () -> Void in
//            center.removeDeliveredNotification(notification)
//        }
//    }
//    
//    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
//        return true
//    }
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    // MARK: - Notifications
//    
//    @objc func serialPortsWereConnected(_ notification: Notification) {
//        if let userInfo = notification.userInfo {
//            let connectedPorts = userInfo[ORSConnectedSerialPortsKey] as! [ORSSerialPort]
//            print("Ports were connected: \(connectedPorts)")
//            self.postUserNotificationForConnectedPorts(connectedPorts)
//            if let arduino = connectedPorts.filter({ $0.name == "usbmodem1411" }).first {
//                self.serialPort = arduino
//                self.serialPort!.delegate = self
//                self.serialPort!.baudRate = 230400 // etc. Do whatever configuration you need
//                
//                
//            }
//        }
//    }
//    
//    @objc func serialPortsWereDisconnected(_ notification: Notification) {
//        if let userInfo = notification.userInfo {
//            let disconnectedPorts: [ORSSerialPort] = userInfo[ORSDisconnectedSerialPortsKey] as! [ORSSerialPort]
//            print("Ports were disconnected: \(disconnectedPorts)")
//            self.postUserNotificationForDisconnectedPorts(disconnectedPorts)
//        }
//    }
//    
//    func postUserNotificationForConnectedPorts(_ connectedPorts: [ORSSerialPort]) {
//        let unc = NSUserNotificationCenter.default
//        for port in connectedPorts {
//            let userNote = NSUserNotification()
//            userNote.title = NSLocalizedString("Serial Port Connected", comment: "Serial Port Connected")
//            userNote.informativeText = "Serial Port \(port.name) was connected to your Mac."
//            userNote.soundName = nil;
//            unc.deliver(userNote)
//        }
//    }
//    
//    func postUserNotificationForDisconnectedPorts(_ disconnectedPorts: [ORSSerialPort]) {
//        let unc = NSUserNotificationCenter.default
//        for port in disconnectedPorts {
//            let userNote = NSUserNotification()
//            userNote.title = NSLocalizedString("Serial Port Disconnected", comment: "Serial Port Disconnected")
//            userNote.informativeText = "Serial Port \(port.name) was disconnected from your Mac."
//            userNote.soundName = nil;
//            unc.deliver(userNote)
//        }
//    }
//}

