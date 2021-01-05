//
//  ServerViewController.swift
//  multiphone
//
//  Created by El Capitan on 1/3/21.
//  Copyright © 2021 Noah Rubin Technologies LLC. All rights reserved.
//

import UIKit

class ServerViewController: UIViewController, UITextFieldDelegate, WebSocketDelegateSimple {
    @IBOutlet weak var ipAddressField: UITextField!
    @IBOutlet weak var portField: UITextField!
    @IBOutlet weak var phoneIdField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        WebSocketManager.shared.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        ipAddressField.delegate = self
        portField.delegate = self
        phoneIdField.delegate = self
        
//        if let ipAddress = NSUserDefaults.standardUserDefaults().stringForKey("ipAddress") {
//            ipAddressField.text = ipAddress
//        }
//        
//        if let port = NSUserDefaults.standardUserDefaults().stringForKey("port") {
//            portField.text = port
//        }
        
        if let phoneId = NSUserDefaults.standardUserDefaults().stringForKey("phoneId") {
            phoneIdField.text = phoneId
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onConnectTapped(sender: AnyObject) {
        WebSocketManager.shared.connect(ipAddressField.text!, portField.text!, phoneIdField.text!)
    }
    
    func websocketDidReceiveMessage(text: String) {
//        if text == "shrek" {
//            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("shrek")
//            self.presentViewController(vc, animated: true, completion: nil)
//        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

