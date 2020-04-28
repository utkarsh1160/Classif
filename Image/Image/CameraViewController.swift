//
//  CameraViewController.swift
//  Image
//
//  Created by Anish Bajaj on 4/15/20.
//  Copyright © 2020 Utkarsh Nath. All rights reserved.
//

import UIKit
import AVKit
import CoreML
import Vision


class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    let session = AVCaptureSession()
        var camera : AVCaptureDevice?
        var cameraPreviewLayer : AVCaptureVideoPreviewLayer?
        var cameraCaptureOutput : AVCapturePhotoOutput?
    let settings = AVCapturePhotoSettings()
    var imagePost : UIImage?
    var classified = false
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
            classified = false
            ImageView.bestGuess = ""
            ImageView.finalBin = ""
            ImageView.finalItem = ""
            settings.flashMode = .off
        }
        
        func displayCapturedPhoto(capturedPhoto : UIImage) {
            imagePost = capturedPhoto
            ImageView.imageToPost = imagePost!
            guard let ciImage = CIImage(image: imagePost!) else {
                fatalError("couldn't convert UIImage to CIImage")
            }
            self.imageClassify(image: ciImage)
            // performSegue(withIdentifier: "cameraOutput", sender: nil)
            while (!classified) {}
            performSegue(withIdentifier: "resultSegue1", sender: nil)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.destination is ImageView {
//            ImageView.imageToPost = imagePost!
//        }
        if let dest = segue.destination as? Result {
            let binType = ImageView.finalBin
            if binType == "compost" {
                dest.view.backgroundColor = dest.greenColor
            } else if binType == "recycle" {
                dest.view.backgroundColor = dest.blueColor
            } else {
                dest.view.backgroundColor = dest.greyColor
            }
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

extension CameraViewController {
func imageClassify(image: CIImage) {
    // Load the ML model through its generated class
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
            fatalError("can't load Places ML model")
        }
    // Create a Vision request with completion handler
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            let results = request.results as? [VNClassificationObservation]
            var outputText = ""
            var possibleItems = [Int: String]()
            var correspondingConfidence = [Int]()
            let arrayBestGuess = results![0].identifier.components(separatedBy: ", ")
            ImageView.bestGuess = arrayBestGuess[0]
            for res in results![0...5] {
                let array = res.identifier.components(separatedBy: ", ")
                print(array)
                for item in array {
                    let confidence = (Int(res.confidence * 100))
                    outputText += "\(confidence)%: \(item)\n"
                    if ImageView.dict[item.lowercased()] != nil {
                        possibleItems[confidence] = item
                        correspondingConfidence.append(confidence)
                    }
                }
            }
            self?.assign_tag(items: possibleItems, confidencesTemp: correspondingConfidence)
        }
    // Run the CoreML3 Resnet50 classifier on global dispatch queue
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
          do {
            try handler.perform([request])
            } catch {
              print(error)
            }
          }
        }
        
        func assign_tag(items: [Int: String], confidencesTemp: [Int]) {
            var confidences = confidencesTemp
            confidences.sort()
            var count = 1
            for confidence in confidences {
                let item = items[confidence]!
                print(count)
                count += 1
                print("\(confidence) \(item)")
                if let bin = ImageView.dict[item]  {
                    ImageView.finalBin = bin
                    ImageView.finalItem = item
                }
            }
            classified = true
        }
}

