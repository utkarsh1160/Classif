//
//  ViewController.swift
//  Image
//
//  Created by Utkarsh Nath on 4/14/20.
//  Copyright © 2020 Utkarsh Nath. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var libraryButtonOutlet: UIButton!
    @IBOutlet weak var cameraButtonOutlet: UIButton!
    var imagePost = UIImage()
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "backFromPreview", sender: sender)
    }
    var imagePickerViewController = UIImagePickerController()
    
    @IBAction func previewImage(_ sender: Any) {
        performSegue(withIdentifier: "previewSegue", sender: sender)
    }
    
    @IBAction func imageClick(_ sender: Any) {
//        print("select photo from camera")
//        imagePickerViewController.delegate = self
//        imagePickerViewController.sourceType = .camera
//        present(imagePickerViewController, animated: true,completion: nil)
        cameraButtonOutlet.backgroundColor = UIColor(red: 0.81, green: 0.81, blue: 0.81, alpha: 1.0)
        performSegue(withIdentifier: "cameraSegue", sender: sender)
        
    }
    
    @IBAction func imageImport(_ sender: Any) {
        print("select from library")
        libraryButtonOutlet.backgroundColor = UIColor(red: 0.81, green: 0.81, blue: 0.81, alpha: 1.0)
        self.imagePickerViewController.sourceType = .photoLibrary
        present(imagePickerViewController,animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imagePost = image
        }
        
        imagePickerViewController.dismiss(animated: true, completion: nil)
        
        performSegue(withIdentifier: "previewSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePickerViewController.delegate = self
        self.imagePickerViewController.sourceType = .photoLibrary
        libraryButtonOutlet.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        cameraButtonOutlet.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ImageView {
            dest.imageToPost = imagePost 
        }
    }

}

