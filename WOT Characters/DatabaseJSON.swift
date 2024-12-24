//
//  DatabaseJSON.swift
//  WOT Characters
//
//  Created by Curtis Franz on 2021-02-21.
//

import UIKit

class DatabaseJSON: UIViewController {
    
    var result: Characters?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseJSON()
    }
    private func parseJSON() {
        guard let path = Bundle.main.path(
                forResource: "book-01",
                ofType: "json"
        ) else {
            return
        }
        let url = URL(fileURLWithPath: path)
        
        do {
            let jsonData = try Data(contentsOf: url)
            result = try JSONDecoder().decode(Characters.self, from: jsonData)
            
            if let result = result {
                print(result)
            }
            else {
                print("Failed to parse")
            }
            return
        }
        catch {
            print("Error: \(error)")
        }
    }
}

//struct Character: Codable, Identifiable {
//    let id: String
//    let name: String
//    let chapter: String
//    let info: String
//}

//struct Book: Identifiable {
//    let id: String
//    let name: String
//    let fileName: String
//}

//struct Chapter: Codable {
//    let title: String
//    let info: String
//    let seeAlso: [SeeAlso]
//}

//struct SeeAlso: Codable, Identifiable {
//    let id: String
//    let name: String
//}

typealias Characters = [String: Character]
