//
//  CharactersViewModel.swift
//  WOT Characters
//
//  Created by Curtis Franz on 2024-12-23.
//

import SwiftUI

// Characters View
class CharactersViewModel: ObservableObject {
    @Published var characters: [Character] = []
    
    func loadCharacters(from fileName: String) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            assertionFailure("JSON file not found: \(fileName)")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let jsonData = try Data(contentsOf: url)
            self.characters = try JSONDecoder().decode([Character].self, from: jsonData)
        } catch {
            assertionFailure("Error parsing JSON: \(error)")
        }
    }
}

struct Character: Identifiable, Codable {
    let id: String
    let name: String
    let chapter: String
    let info: String
}
