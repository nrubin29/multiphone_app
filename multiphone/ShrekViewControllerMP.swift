//
//  ShrekViewController.swift
//  multiphone
//
//  Created by El Capitan on 1/4/21.
//  Copyright © 2021 Noah Rubin Technologies LLC. All rights reserved.
//

import UIKit
import MediaPlayer

class ShrekViewControllerMP: UIViewController, WebSocketDelegateSimple {
    private var player: MPMoviePlayerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WebSocketManager.shared.delegate = self
        
        let videoPath = NSBundle.mainBundle().pathForResource("shrek", ofType: "mov")!
        let videoUrl = NSURL(fileURLWithPath: videoPath)
        // let frame = CGRectMake(0, 0, self.view.window!.frame.width, self.view.window?.frame.height)
        
        self.player = MPMoviePlayerController(contentURL: videoUrl)
        self.player.movieSourceType = .File
        self.player.controlStyle = .None
        self.player.view.frame = UIScreen.mainScreen().bounds // frame
        self.view.addSubview(self.player.view)
        
        WebSocketManager.shared.ready()
    }
    
    func websocketDidReceiveMessage(text: String) {
        if text == "full" {
            self.player.prepareToPlay()
            self.player.pause()
            
            WebSocketManager.shared.ready()
        }
        
        else if text == "short" {
            self.player.currentPlaybackTime = 2
            self.player.prepareToPlay()
            self.player.pause()
            
            WebSocketManager.shared.ready()
        }
        
        else if text == "play" {
            self.player.play()
        }
    }
}
