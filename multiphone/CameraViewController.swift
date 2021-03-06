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
    @IBOutlet weak var imageView: UIImageView!
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCaptureStillImageOutput!
    var videoConnection: AVCaptureConnection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WebSocketManager.shared.delegate = self
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let videoInput = try! AVCaptureDeviceInput(device: backCamera)
        captureSession.addInput(videoInput)
        
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        captureSession.addOutput(stillImageOutput)
        
        videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo)
        
        captureSession.startRunning()
        
        WebSocketManager.shared.ready()
    }
 
    func websocketDidReceiveMessage(text: String) {
        stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) { (imageSampleBuffer : CMSampleBuffer!, _) in
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer)
            let imageBase64 = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            
            WebSocketManager.shared.send("image \(imageBase64)")
            let image = UIImage(data: imageData)
            self.imageView.image = image
        }
    }
}
