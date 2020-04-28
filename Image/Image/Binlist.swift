//
//  Binlist.swift
//  Image
//
//  Created by Ikshita Puri on 4/20/20.
//  Copyright © 2020 Utkarsh Nath. All rights reserved.
//

import Foundation

struct DemoData: Codable {
    let item: String
    let bin: String 
}

class binlist
{
    func readLocalFile(forName name: String) -> Data? {
    do {
        if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
            let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
            return jsonData
        }
    } catch {
        print(error)
    }
    return nil
}

func parse(jsonData: Data) {
    do {
        let decodedData = try JSONDecoder().decode(DemoData.self, from: jsonData)
        print("Item: ", decodedData.item)
        print("Bin: ", decodedData.bin)
        print("===============")
    } catch {
        print("decode error")
    }
}

}
