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
import Firebase




class ImageView: UIViewController {

    @IBOutlet weak var previewImage: UIImageView!
    static var imageToPost = UIImage()
    @IBOutlet weak var answerLabel: UILabel!
    static var dict = Items.dict
    static var finalBin = ""
    static var finalItem = ""
    static var bestGuess = ""
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "backFromPreview", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Unlock the next line once camera is active
        previewImage.image = ImageView.imageToPost
        ImageView.finalBin = ""
        ImageView.finalItem = ""
        
        guard let ciImage = CIImage(image: previewImage.image!) else {
            fatalError("couldn't convert UIImage to CIImage")
        }
        imageClassify(image: ciImage)
        performSegue(withIdentifier: "resultSegue", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func viewResultButton(_ sender: Any) {
        performSegue(withIdentifier: "resultSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        var possibleItems = [Int: String]()
        var correspondingConfidence = [Int]()
        let arrayBestGuess = results![0].identifier.components(separatedBy: ", ")
        ImageView.bestGuess = arrayBestGuess[0]
        let ref = Database.database().reference()
        ref.child("newDictionary").observe(.value)
        { (snapshot) in
            let newDict = (snapshot.value as? [String: String])!
            for res in results![0...5] {
                let array = res.identifier.components(separatedBy: ", ")
                print(array)
                for item in array {
                    let confidence = (Int(res.confidence * 100))
                    outputText += "\(confidence)%: \(item)\n"
                    if newDict[item.lowercased()] != nil {
                        possibleItems[confidence] = item
                        correspondingConfidence.append(confidence)
                    }
                }
            }
            var confidences = correspondingConfidence
            confidences.sort()
            var count = 1
            for confidence in confidences {
                let item = possibleItems[confidence]!
                print(count)
                count += 1
                print("\(confidence) \(item)")
                if let bin = newDict[item]  {
                    ImageView.finalBin = bin
                    ImageView.finalItem = item
                }
            }
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
    }
}
