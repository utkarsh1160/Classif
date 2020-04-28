//
//  Items.swift
//  Image
//
//  Created by Anish Bajaj on 4/27/20.
//  Copyright © 2020 Utkarsh Nath. All rights reserved.
//

import UIKit
import Firebase

class Items: UIViewController {
    
    
    static var dict: [String: String] = [
        "remote control": "recycle",
        "switch": "recycle",
        "electric switch": "recycle",
        "binder": "landfill",
        "compact disc": "recycle",
        "flowerpot": "compost",
        "cd": "recycle",
        "aerosol can": "compost",
        "bottle": "compost",
        "packet": "recycle",
        "container": "recycle",
        "lid": "landfill",
        "furniture": "compost",
        "basket": "compost",
        "bucket": "recycle",
        "water bottle": "recycle",
        "garbage can": "compost",
        "glass bottles": "compost",
        "liquor bottles": "compost",
        "glass jars": "recycle",
        "newspaper": "compost",
        "books": "compost",
        "book": "compost",
        "phonebook": "compost",
        "magazine": "compost",
        "milk carton": "compost",
        "juice carton": "compost",
        "scrap paper": "compost",
        "junk mail": "compost",
        "paper towel cardboard roll": "compost",
        "toilet paper cardboard roll": "compost",
        "pizza box": "compost",
        "aluminum": "compost",
        "pots and pans": "compost",
        "paper coffee cups": "compost",
        "cardboard boxes": "compost",
        "garbage": "recycle",
        "food waste": "recycle",
        "takeout containers": "recycle",
        "wrapping paper": "recycle",
        "garden hoses": "recycle",
        "incandescent light bulbs": "recycle",
        "latex paint can": "recycle",
        "wet strength paper": "recycle",
        "paper towels": "recycle",
        "tissues": "recycle",
        "napkins": "recycle",
        "hangers": "recycle",
        "yard waste": "landfill",
        "christmas tree": "landfill",
        "tires": "landfill",
        "electronics": "landfill",
        "air conditioners": "landfill",
        "led light bulbs": "landfill",
        "fluorescent light bulbs": "landfill",
        "household hazards": "landfill",
        "household cleaners": "landfill",
        "pesticides": "landfill",
        "fertilizers": "landfill",
        "pool chemicals": "landfill",
        "oil paints": "landfill",
        "acrylic paints": "landfill",
        "oil-based paints": "landfill",
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
