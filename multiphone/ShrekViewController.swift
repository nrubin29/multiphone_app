//
//  ShrekViewController.swift
//  multiphone
//
//  Created by El Capitan on 1/4/21.
//  Copyright © 2021 Noah Rubin Technologies LLC. All rights reserved.
//

import UIKit
import AVFoundation

class ShrekViewController: UIViewController, WebSocketDelegateSimple {
    private var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WebSocketManager.shared.delegate = self
        self.view.backgroundColor = UIColor.blackColor()
        
        let videoPath = NSBundle.mainBundle().pathForResource("shrek", ofType: "mov")!
        let videoUrl = NSURL(fileURLWithPath: videoPath)
        // For some reason, UIScreen.mainScreen().bounds is (0, 0, 320, 480) on the iPhone 4 (iOS 7)
        let frame = CGRectMake(0, 0, 480, 320)
        
        self.player = AVPlayer(URL: videoUrl)
        let layer = AVPlayerLayer(player: self.player)
        layer.frame = frame // UIScreen.mainScreen().bounds
        
        self.view.layer.addSublayer(layer)
        
        WebSocketManager.shared.ready()
    }
    
    func websocketDidReceiveMessage(text: String) {
        if text == "full" {
            WebSocketManager.shared.ready()
        }
            
        else if text == "short" {
            self.player.seekToTime(CMTimeMakeWithSeconds(1.5, 600), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
            WebSocketManager.shared.ready()
        }
            
        else if text == "play" {
            self.player.play()
        }
    }
}
