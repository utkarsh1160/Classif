//
//  CameraViewController.swift
//  Image
//
//  Created by Anish Bajaj on 4/15/20.
//  Copyright © 2020 Utkarsh Nath. All rights reserved.
//

import UIKit
import AVKit

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    @IBOutlet weak var captureButtonJustBorder: UIButton!
    let session = AVCaptureSession()
        var camera : AVCaptureDevice?
        var cameraPreviewLayer : AVCaptureVideoPreviewLayer?
        var cameraCaptureOutput : AVCapturePhotoOutput?
    let settings = AVCapturePhotoSettings()
    var imagePost : UIImage?
        @IBAction func flashMode(_ sender: UIButton) {
            if settings.flashMode == .on {
                settings.flashMode = .off
                sender.setBackgroundImage(UIImage(systemName: "lightbulb"), for: UIControl.State.normal)
            }
            else {
                settings.flashMode = .on
                sender.setBackgroundImage(UIImage(systemName: "lightbulb.fill"), for: UIControl.State.normal)
            }
        }
        @IBAction func backButton(_ sender: Any) {
            performSegue(withIdentifier: "backFromCamera", sender: sender)
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            initializeCaptureSession()
            // Do any additional setup after loading the view, typically from a nib.
            settings.flashMode = .off
            captureButtonJustBorder.layer.cornerRadius = 40
            captureButtonJustBorder.layer.borderWidth = 5
            captureButtonJustBorder.layer.borderColor = UIColor.white.cgColor
        }
        
        func displayCapturedPhoto(capturedPhoto : UIImage) {
            imagePost = capturedPhoto
            performSegue(withIdentifier: "cameraOutput", sender: nil)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ImageView {
            dest.imageToPost = imagePost!
        }
    }
        
        @IBAction func takePicture(_ sender: Any) {
            
            takePicture()
        }
        
        func initializeCaptureSession() {
            
            session.sessionPreset = AVCaptureSession.Preset.high
            camera = AVCaptureDevice.default(for: .video)
            
            do {
                let cameraCaptureInput = try AVCaptureDeviceInput(device: camera!)
                cameraCaptureOutput = AVCapturePhotoOutput()
                
                session.addInput(cameraCaptureInput)
                session.addOutput(cameraCaptureOutput!)
                
            } catch {
                print(error.localizedDescription)
            }
            
            cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
            cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            cameraPreviewLayer?.frame = view.bounds
            cameraPreviewLayer?.connection!.videoOrientation = AVCaptureVideoOrientation.portrait
            
            view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
            
            session.startRunning()
        }
        
        func takePicture() {
            
            cameraCaptureOutput?.capturePhoto(with: settings, delegate: self)
        }
    }

    extension CameraViewController {
        
        func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
            
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            } else {
                
                if let sampleBuffer = photoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) {
                    
                    if let finalImage = UIImage(data: dataImage) {
                        
                        displayCapturedPhoto(capturedPhoto: finalImage)
                    }
                }
            }
        }
    }
