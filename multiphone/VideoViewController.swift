//
//  VideoViewController.swift
//  multiphone
//
//  Created by El Capitan on 1/5/21.
//  Copyright © 2021 Noah Rubin Technologies LLC. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController, WebSocketDelegateSimple {
    private var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WebSocketManager.shared.delegate = self
        self.view.backgroundColor = UIColor.blackColor()
        
        WebSocketManager.shared.ready()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.player.removeObserver(self, forKeyPath: "status")
    }
    
    func websocketDidReceiveMessage(text: String) {
        if text == "play" {
            self.player.play()
            return
        }
        
        let args = text.componentsSeparatedByString(" ")
        let videoName = args[0]
        let videoWidth = CGFloat(Double(args[1])!)
        let videoHeight = CGFloat(Double(args[2])!)
        let x = CGFloat(Double(args[3])!)
        let y = CGFloat(Double(args[4])!)
        let when = NSDate(timeIntervalSince1970: Double(args[5])!)
        print(when)
        
        let videoPath = NSBundle.mainBundle().pathForResource(videoName, ofType: "mov")!
        let videoUrl = NSURL(fileURLWithPath: videoPath)
        let frame = CGRectMake(-x, -y, videoWidth, videoHeight)
        
        self.player = AVPlayer(URL: videoUrl)
        let layer = AVPlayerLayer(player: self.player)
        layer.frame = frame
        self.view.layer.addSublayer(layer)
        
        self.player.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.Initial, context: nil)
        
//        let timer = NSTimer(fireDate: when, interval: 0, target: self, selector: #selector(play), userInfo: nil, repeats: false)
//        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
//        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(onTimerFire), userInfo: nil, repeats: true)
        
//        WebSocketManager.shared.ready()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if object != nil && object! as! NSObject == self.player && keyPath! == "status" {
            if player.status == AVPlayerStatus.ReadyToPlay {
                WebSocketManager.shared.ready()
            }
        }
    }
    
//    func onTimerFire(timer: NSTimer) {
//        print("onTimerFire")
//        
//        if (timer.fireDate.compare(NSDate()) == .OrderedAscending) {
//            self.player.play()
//            timer.invalidate()
//        }
//    }
    
//    func play() {
//        self.player.play()
//    }
}
