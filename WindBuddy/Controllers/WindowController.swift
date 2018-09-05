//
//  WindowController.swift
//  WindBuddy
//
//  Created by Mitch Kroska on 9/2/18.
//  Copyright © 2018 Mitch Kroska. All rights reserved.
//

import Cocoa
import ORSSerial

class WindowController: NSWindowController {
    var viewController: ViewController?
    @IBOutlet weak var openCloseButton: NSButton!
    @IBOutlet weak var portConnectionIndicator: NSLevelIndicator!
    
    @IBOutlet weak var compiledIndicator: NSLevelIndicator!
    @objc let serialPortManager = ORSSerialPortManager.shared()
    @objc let availableBaudRates = [300, 1200, 2400, 4800, 9600, 14400, 19200, 28800, 38400, 57600, 115200, 230400]
    
    @objc dynamic var serialPort: ORSSerialPort? {
        didSet {
            oldValue?.close()
            oldValue?.delegate = nil
            serialPort?.delegate = self
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        viewController = ViewController()
        viewController!.windowDelegate = self
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(serialPortsWereConnected(_:)), name: NSNotification.Name.ORSSerialPortsWereConnected, object: nil)
        nc.addObserver(self, selector: #selector(serialPortsWereDisconnected(_:)), name: NSNotification.Name.ORSSerialPortsWereDisconnected, object: nil)
        
        NSUserNotificationCenter.default.delegate = self
//        window?.titleVisibility = .hidden
        
    }
    @IBAction func testConnection(_ sender: Any) {
        print("Test Connection")
        serialPort?.send("$TEST+".data(using: String.Encoding.utf8)!)
    }
    @IBAction func openOrClosePort(_ sender: Any) {
        if let port = self.serialPort {
            if (port.isOpen) {
                port.close()
            } else {
                port.open()
//                self.receivedDataTextView.textStorage?.mutableString.setString("");
            }
        }
        portConnectionIndicator.intValue = 1
    }
    
    @IBAction func syncWindingWithHardware(_ sender: Any) {
        print("Sync Button PRessed")
    }
    
    @IBAction func startWinding(_ sender: Any) {
        print("Start Winding Button pressed")
    }
}

    // MARK: - ORSSerialPortDelegate
extension WindowController: ORSSerialPortDelegate {

    
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        self.openCloseButton.title = "Close"
        let descriptor = ORSSerialPacketDescriptor(prefixString: "!pos", suffixString: ";", maximumPacketLength: 8, userInfo: nil)
        serialPort.startListeningForPackets(matching: descriptor)
    }

    func serialPortWasClosed(_ serialPort: ORSSerialPort) {
        self.openCloseButton.title = "Open"
    }

//    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
//        if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
//            self.receivedDataTextView.textStorage?.mutableString.append(string as String)
//            self.receivedDataTextView.needsDisplay = true
//        }
//    }

    func serialPortWasRemoved(fromSystem serialPort: ORSSerialPort) {
        self.serialPort = nil
        self.openCloseButton.title = "Open"
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        print("SerialPort \(serialPort) encountered an error: \(error)")
    }
    
    
}

extension WindowController: NSUserNotificationCenterDelegate {
    @objc func serialPortsWereConnected(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let connectedPorts = userInfo[ORSConnectedSerialPortsKey] as! [ORSSerialPort]
            print("Ports were connected: \(connectedPorts)")
            self.postUserNotificationForConnectedPorts(connectedPorts)
            if let arduino = connectedPorts.filter({ $0.name == "usbmodem1411" }).first {
                self.serialPort = arduino
                self.serialPort!.delegate = self
                self.serialPort!.baudRate = 230400 // etc. Do whatever configuration you need
                
                
            }
        }
    }
    
    @objc func serialPortsWereDisconnected(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let disconnectedPorts: [ORSSerialPort] = userInfo[ORSDisconnectedSerialPortsKey] as! [ORSSerialPort]
            print("Ports were disconnected: \(disconnectedPorts)")
            self.postUserNotificationForDisconnectedPorts(disconnectedPorts)
        }
    }
    
    func postUserNotificationForConnectedPorts(_ connectedPorts: [ORSSerialPort]) {
        let unc = NSUserNotificationCenter.default
        for port in connectedPorts {
            let userNote = NSUserNotification()
            userNote.title = NSLocalizedString("Serial Port Connected", comment: "Serial Port Connected")
            userNote.informativeText = "Serial Port \(port.name) was connected to your Mac."
            userNote.soundName = nil;
            unc.deliver(userNote)
        }
    }
    
    func postUserNotificationForDisconnectedPorts(_ disconnectedPorts: [ORSSerialPort]) {
        let unc = NSUserNotificationCenter.default
        for port in disconnectedPorts {
            let userNote = NSUserNotification()
            userNote.title = NSLocalizedString("Serial Port Disconnected", comment: "Serial Port Disconnected")
            userNote.informativeText = "Serial Port \(port.name) was disconnected from your Mac."
            userNote.soundName = nil;
            unc.deliver(userNote)
        }
    }
}

extension WindowController: WindowControllerDelegate {
    func didCompile() {
        print("yooooooo")
       compiledIndicator.intValue = 1
    }
    
    
}
