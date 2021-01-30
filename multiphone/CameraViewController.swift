//
//  CameraViewController.swift
//  multiphone
//
//  Created by El Capitan on 1/11/21.
//  Copyright © 2021 Noah Rubin Technologies LLC. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, WebSocketDelegateSimple {
    override func viewDidLoad() {
        super.viewDidLoad()
        WebSocketManager.shared.delegate = self
        
        WebSocketManager.shared.ready()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func websocketDidReceiveMessage(text: String) {
        
    }
}
