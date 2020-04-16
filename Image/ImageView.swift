//
//  ImageView.swift
//  Image
//
//  Created by Utkarsh Nath on 4/14/20.
//  Copyright © 2020 Utkarsh Nath. All rights reserved.
//

import CoreML
import UIKit
import Vision

class ImageView: UIViewController {

    @IBOutlet weak var previewImage: UIImageView!
    var imageToPost = UIImage()
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "backFromPreview", sender: sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Unlock the next line once camera is active
        previewImage.image = imageToPost
        
        guard let ciImage = CIImage(image: previewImage.image!) else {
        fatalError("couldn't convert UIImage to CIImage")
            }
        imageClassify(image: ciImage)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ImageView {
func imageClassify(image: CIImage) {
    answerLabel.text = "detecting..."
// Load the ML model through its generated class
    guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
        fatalError("can't load Places ML model")
    }
// Create a Vision request with completion handler
    let request = VNCoreMLRequest(model: model) { [weak self] request, error in
      let results = request.results as? [VNClassificationObservation]
      var outputText = ""
        for res in results!{
        outputText += "\(Int(res.confidence * 100))% it's \(res.identifier)\n"
      }
      DispatchQueue.main.async { [weak self] in
          self?.answerLabel.text! = outputText
      }
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
  }
