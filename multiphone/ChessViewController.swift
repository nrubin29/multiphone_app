//
//  ChessViewController.swift
//  multiphone
//
//  Created by El Capitan on 1/28/21.
//  Copyright © 2021 Noah Rubin Technologies LLC. All rights reserved.
//

import UIKit

let CHESS_PIECES = [
    ["♔", "♕", "♖", "♗", "♘", "♙"],
    ["♚", "♛", "♜", "♝", "♞", "♟"]
];

class ChessViewController: UIViewController, WebSocketDelegateSimple {
    @IBOutlet weak var pieceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WebSocketManager.shared.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTouch))
        view.userInteractionEnabled = true
        view.addGestureRecognizer(tap)
        
        WebSocketManager.shared.ready()
    }
    
    func websocketDidReceiveMessage(text: String) {
        let args = text.componentsSeparatedByString(" ")
        
        if args[0] == "empty" {
            pieceLabel.text = ""
            return
        }
        
        let piece = Int(args[0])!
        let color = Int(args[1])!
        
        pieceLabel.text = CHESS_PIECES[color][piece]
        
        if args.count > 2 {
            let row = Int(args[2])!
            let col = Int(args[3])!
            
            if row + col % 2 == 0 {
                self.view.backgroundColor = UIColor.grayColor()
            }
        }
    }
    
    func onTouch() {
        WebSocketManager.shared.send("tapped")
    }
}
