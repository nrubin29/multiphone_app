//
//  ConnectedViewController.swift
//  multiphone
//
//  Created by El Capitan on 1/4/21.
//  Copyright © 2021 Noah Rubin Technologies LLC. All rights reserved.
//

import UIKit

class ConnectedViewController: UIViewController, WebSocketDelegateSimple {
    @IBOutlet weak var numberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberLabel.text = WebSocketManager.shared.phoneId
    }
    
    override func viewDidAppear(animated: Bool) {
        // This needs to be in viewDidAppear() because we need to set the delegate again after dismissing a view.
        WebSocketManager.shared.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func websocketDidReceiveMessage(text: String) {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier(text)
        self.presentViewController(vc, animated: true, completion: nil)
    }
}

