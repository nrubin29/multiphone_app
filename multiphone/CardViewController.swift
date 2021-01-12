//
//  CardViewController.swift
//  multiphone
//
//  Created by El Capitan on 1/11/21.
//  Copyright © 2021 Noah Rubin Technologies LLC. All rights reserved.
//

import UIKit

class CardViewController: UIViewController, WebSocketDelegateSimple {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WebSocketManager.shared.delegate = self
    }
    
    func websocketDidReceiveMessage(text: String) {
        imageView.image = UIImage(named: text)
    }
}
