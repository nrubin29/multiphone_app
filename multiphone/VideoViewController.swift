//
//  VideoViewController.swift
//  multiphone
//
//  Created by El Capitan on 1/5/21.
//  Copyright © 2021 Noah Rubin Technologies LLC. All rights reserved.
//

import UIKit
import MediaPlayer

class VideoViewController: UIViewController, WebSocketDelegateSimple {
    private var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WebSocketManager.shared.delegate = self
        self.view.backgroundColor = UIColor.blackColor()
    }
    
    func websocketDidReceiveMessage(text: String) {
        if text == "play" {
            self.player.play()
        }
        
        else {
            let args = text.componentsSeparatedByString(" ")
            let videoName = args[0]
            let videoWidth = CGFloat(Double(args[1])!)
            let videoHeight = CGFloat(Double(args[2])!)
            let x = CGFloat(Double(args[3])!)
            let y = CGFloat(Double(args[4])!)
            
            let videoPath = NSBundle.mainBundle().pathForResource(videoName, ofType: "mov")!
            print(videoPath)
            let videoUrl = NSURL(fileURLWithPath: videoPath)
            print(videoUrl)
            let frame = CGRectMake(-x, -y, videoWidth, videoHeight)
            print(frame)
            
            self.player = AVPlayer(URL: videoUrl)
            print(self.player)
            let layer = AVPlayerLayer(player: self.player)
            layer.frame = frame
            
            self.view.layer.addSublayer(layer)
            
            WebSocketManager.shared.send("ready")
            print("Ready")
        }
    }
}
