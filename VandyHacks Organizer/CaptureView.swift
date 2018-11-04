//
//  CaptureView.swift
//  VandyHacks Organizer
//
//  Created by Bruce Brookshire on 11/2/18.
//  Copyright © 2018 bruce-brookshire.com. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion
import AVFoundation

class CaptureView: UIViewController {
    
    
    @IBOutlet weak var captureView: UIView!
    @IBOutlet weak var captureBtn: UIButton!
    @IBOutlet weak var imagesLbl: UILabel!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    var deviceOrientationOnCapture: UIDeviceOrientation?
    var capturedPhoto: UIImage?
    
    var imageManager = ImageManager()
    var motion: CMMotionManager!
    var location = ""
    
    var timer: Timer?
    
    var running = false
    
    var images = 0
    
    
    override func viewDidLoad() {
        captureBtn.layer.cornerRadius = 10
        captureBtn.layer.borderColor = self.view.tintColor.cgColor
        captureBtn.layer.borderWidth = 2
        
        self.title = "Capture SLAMMY"
        
        loadCamera()
        motion = CMMotionManager()
    }
    
    func loadCamera() {
        Thread {
            Thread.current.qualityOfService = .userInteractive
            do {
                let input = try AVCaptureDeviceInput(device: self.cameraWithPosition(.back)!)
                self.captureSession = AVCaptureSession()
                self.captureSession?.addInput(input)
                
                self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
                self.videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                DispatchQueue.main.async {
                    self.videoPreviewLayer?.frame = self.captureView.layer.bounds
                    self.captureView.layer.addSublayer(self.videoPreviewLayer!)
                }
                
                self.captureSession?.startRunning()
                
                self.capturePhotoOutput = AVCapturePhotoOutput()
                self.capturePhotoOutput?.isHighResolutionCaptureEnabled = true
                
                self.captureSession?.addOutput(self.capturePhotoOutput!)
            } catch {
                if AVCaptureDevice.authorizationStatus(for: .video) == .denied {
                    DispatchQueue.main.async {
                        
                        let alert = UIAlertController(title: "Issue",
                                                      message: "It looks like you have denied access for Skoller to use the camera. Open Skoller in settings and enable camera access",
                                                      preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
                        alert.addAction(UIAlertAction(title: "Fix", style: .default, handler: { (action) in
                            let url = URL(string: UIApplication.openSettingsURLString)!
                            if UIApplication.shared.canOpenURL(url)
                            {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }
            }.start()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.captureView.backgroundColor = .white
        })
    }
    
    // Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
    func cameraWithPosition(_ position: AVCaptureDevice.Position) -> AVCaptureDevice?
    {
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: position).devices
        return devices.count == 1 ? devices[0] : nil
    }
    
    @IBAction func tappedCapture() {
        
        if running {
            running = false
            
            self.timer!.invalidate()
            
            captureBtn.setTitle("Capture", for: .normal)
            captureBtn.setTitleColor(self.view.tintColor, for: .normal)
            captureBtn.layer.borderColor = self.view.tintColor.cgColor
            
            captureView.isHidden = true
            
            Requests.uploadImages(imageData: imageManager.endSession()) { (completion) in
                DispatchQueue.main.async {
                    self.imagesLbl.text = "\(completion)% uploaded"
                    if Int(completion) == 100 {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        } else {
            running = true
            imageManager.startSession()
            
            let frequency = 1.0 / 5.0
            
            if self.motion.isAccelerometerAvailable {
                self.motion.accelerometerUpdateInterval = frequency
                self.motion.gyroUpdateInterval = frequency
                self.motion.magnetometerUpdateInterval = frequency
                
                self.motion.startAccelerometerUpdates()
                self.motion.startGyroUpdates()
                self.motion.startMagnetometerUpdates()
            }
            
            self.timer = Timer(fire: Date(), interval: frequency, repeats: true, block: { (timer) in
                let settings = AVCapturePhotoSettings()
                settings.isHighResolutionPhotoEnabled = true
                self.capturePhotoOutput?.capturePhoto(with: settings, delegate: self)
            })
            
            RunLoop.current.add(timer!, forMode: .default)
            
            captureBtn.setTitle("Stop", for: .normal)
            captureBtn.setTitleColor(.red, for: .normal)
            captureBtn.layer.borderColor = UIColor.red.cgColor
        }
    }
}


extension CaptureView:  AVCapturePhotoCaptureDelegate
{
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print("Error capturing photo: \(error)")
        } else {
            
            guard
                let sampleBuffer = photoSampleBuffer,
                let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer),
                let image = UIImage(data: dataImage),
                let accelerometerData = self.motion.accelerometerData,
                let magnetometerData = self.motion.magnetometerData,
                let gyroData = self.motion.gyroData
                else { return }
            
            imageManager.acceptImage(image: image, accelerometerData: accelerometerData, magnetometerData: magnetometerData, gyroData: gyroData)
            images += 1
            imagesLbl.text = "Images: \(images)"
        }
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        self.deviceOrientationOnCapture = UIDevice.current.orientation
    }
}
