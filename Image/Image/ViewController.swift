//
//  ViewController.swift
//  Image
//
//  Created by Utkarsh Nath on 4/14/20.
//  Copyright © 2020 Utkarsh Nath. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imagePost = UIImage()
    var ref = Database.database().reference()
    
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
        
        performSegue(withIdentifier: "cameraSegue", sender: sender)
        
    }
    
    @IBAction func imageImport(_ sender: Any) {
        print("select from library")
        self.imagePickerViewController.sourceType = .photoLibrary
        present(imagePickerViewController,animated: true,completion: nil)
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
        // Do any additional setup after loading the view.
//        ref = Database.database().reference()
//        ref.child("newDictionary").observe(.value)
//        { (snapshot) in
//            let newDict = (snapshot.value as? [String: String])!
//            print(newDict)
//        }
    }
    
    func writeToFir(ref: DatabaseReference) {
        let itemBinPair = ref.child("newDictionary")
        itemBinPair.setValue(Items.dict)
    }
    
    static func readFromFir(ref: DatabaseReference) -> [String: String] {
        var retDict = [String: String]()
        ref.child("newDictionary").observe(.value)
        { (snapshot) in
            let newDict = (snapshot.value as? [String: String])!
            print(newDict)
            Items.dict = newDict
        }
        return retDict
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ImageView {
            ImageView.imageToPost = imagePost 
        }
    }

}

