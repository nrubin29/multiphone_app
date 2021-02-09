//
//  WebSocketManager.swift
//  multiphone
//
//  Created by El Capitan on 1/3/21.
//  Copyright © 2021 Noah Rubin Technologies LLC. All rights reserved.
//

import UIKit
import Starscream

public protocol WebSocketDelegateSimple: class {
    func websocketDidReceiveMessage(text: String)
}

class WebSocketManager: WebSocketDelegate {
    static var shared = WebSocketManager()
    
    private init() {}
    
    private var socket: WebSocket!
    var delegate: WebSocketDelegateSimple?
    
    var phoneId: String!
    var isConnected = false
    
    func connect(ipAddress: String, _ port: String, _ phoneId: String) {
        self.phoneId = phoneId
        self.socket = WebSocket(url: NSURL(string: "ws://\(ipAddress):\(port)/")!)
        self.socket.delegate = self
        self.socket.connect()
        
        NSUserDefaults.standardUserDefaults().setObject(ipAddress, forKey: "ipAddress")
        NSUserDefaults.standardUserDefaults().setObject(port, forKey: "port")
        NSUserDefaults.standardUserDefaults().setObject(phoneId, forKey: "phoneId")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func send(text: String) {
        self.socket.writeString(text)
    }
    
    func ready() {
        self.socket.writeString("ready")
    }
    
    func websocketDidConnect(socket: WebSocket) {
        print("websocketDidConnect()")
        socket.writeString("phoneId \(self.phoneId)")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("websocketDidDisconnect() error: \(error)")
        isConnected = false
        self.popToServerViewController()
    }
    
    private func popToServerViewController() {
        if let topViewController = getTopViewController() where !(topViewController is ServerViewController) {
            topViewController.dismissViewControllerAnimated(true) { self.popToServerViewController() }
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("websocketDidReceiveMessage(): \(text)")
        
        if text == "connected" {
            isConnected = true
            
            if let topViewController = getTopViewController() {
                let vc = topViewController.storyboard!.instantiateViewControllerWithIdentifier("connected")
                topViewController.presentViewController(vc, animated: true, completion: nil)
            }
        }
        
        else if text == "exit" {
            if let topViewController = getTopViewController() {
                topViewController.dismissViewControllerAnimated(true, completion: nil)
            }
        }
            
        else if text.hasPrefix("orientation") && text.componentsSeparatedByString(" ").count > 1 {
            let orientations = [
                "left": UIInterfaceOrientation.LandscapeLeft.rawValue,
                "right": UIInterfaceOrientation.LandscapeRight.rawValue,
                "up": UIInterfaceOrientation.Portrait.rawValue
            ]
            
            UIDevice.currentDevice().setValue(orientations[text.componentsSeparatedByString(" ")[1]], forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
        
        else {
            self.delegate?.websocketDidReceiveMessage(text)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("websocketDidReceiveData(): \(data)")
    }
    
    private func getTopViewController() -> UIViewController? {
        if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        }
        
        return nil
    }
}
