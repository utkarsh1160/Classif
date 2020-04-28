//
//  UpdateDatabase.swift
//  Image
//
//  Created by Anish Bajaj on 4/28/20.
//  Copyright © 2020 Utkarsh Nath. All rights reserved.
//

import UIKit
import Firebase

class UpdateDatabase: UIViewController, UITextFieldDelegate {

    var item = ""
    var bin = ""
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var supposedBin: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemNameLabel.text = "\(item)"
        supposedBin.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        supposedBin.resignFirstResponder()
        return true
    }
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "updateDatabaseToMainSegue", sender: nil)
    }
    
    @IBAction func submitButton(_ sender: Any) {
        if let s = supposedBin.text {
            let databaseFormat = s.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            if databaseFormat != "compost"
                && databaseFormat != "recycle"
                && databaseFormat != "landfill" {
                let alertController = UIAlertController(title: "Incorrect Format", message:
                       "App only supports compost, recycle, and landfill bins", preferredStyle: .alert)
                   alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                   self.present(alertController, animated: true, completion: nil)
            } else {
                let ref = Database.database().reference()
                ref.child("newDictionary").observe(.value)
                { (snapshot) in
                    var newDict = (snapshot.value as? [String: String])!
                    newDict["\(self.item)"] = s
                    ref.child("newDictionary").setValue(newDict)
                    let alertController = UIAlertController(title: "Submission Saved", message:
                        "Thank you. Our team will review your submission shortly", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            performSegue(withIdentifier: "updateDatabaseToMainSegue", sender: nil)
        }
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
