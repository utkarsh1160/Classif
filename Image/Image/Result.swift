//
//  Result.swift
//  Image
//
//  Created by Anish Bajaj on 4/27/20.
//  Copyright © 2020 Utkarsh Nath. All rights reserved.
//

import UIKit

class Result: UIViewController {

    var binType = ImageView.finalBin
    var item = ImageView.finalItem
    var bestGuess = ImageView.bestGuess
    let greenColor = UIColor(red: 0.216, green: 0.624, blue: 0.478, alpha: 1.0)
    let blueColor = UIColor(red: 0.149, green: 0.678, blue: 0.894, alpha: 1.0)
    let greyColor = UIColor(red: 0.004, green: 0.137, blue: 0.251, alpha: 1)
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var binTypeName: UILabel!
    @IBOutlet weak var goesIntoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if item == "" || binType == "" {
            goesIntoLabel.text = "\(bestGuess) doesn't exist in our database"
        }
        itemName.text = item
        binTypeName.text = binType
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToMain(_ sender: Any) {
        performSegue(withIdentifier: "backToMainSegue", sender: nil)
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
