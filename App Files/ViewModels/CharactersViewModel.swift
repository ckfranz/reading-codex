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

    // Load characters from a specific JSON file
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

    // Load unique characters from multiple books
    func loadAllCharacters(from books: [Book]) {
        var uniqueCharacters: [String: Character] = [:]

        for book in books.reversed() { // Prioritize later books
            guard let path = Bundle.main.path(forResource: book.fileName, ofType: "json") else {
                continue
            }

            let url = URL(fileURLWithPath: path)

            do {
                let jsonData = try Data(contentsOf: url)
                let bookCharacters = try JSONDecoder().decode([Character].self, from: jsonData)

                // Add characters to the dictionary, overwriting earlier entries
                for character in bookCharacters {
                    uniqueCharacters[character.name] = character
                }
            } catch {
                assertionFailure("Error parsing JSON for book \(book.name): \(error)")
            }
        }

        // Update published array with unique characters
        self.characters = Array(uniqueCharacters.values).sorted { $0.name < $1.name }
    }
}

struct Character: Identifiable, Decodable, Hashable {
    let id: String
    let name: String
    let chapters: [String]
    let info: String

    enum CodingKeys: String, CodingKey {
        case id, name, chapter, info
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        info = try container.decode(String.self, forKey: .info)
        
        // Convert "chapter" into "chapters"
        let chapterString = try container.decode(String.self, forKey: .chapter)
        chapters = chapterString
            .components(separatedBy: "Chapter ")
            .compactMap { chapter in
                let trimmed = chapter.trimmingCharacters(in: .whitespacesAndNewlines)
                return trimmed.isEmpty ? nil : "Chapter \(trimmed)"
            }
    }
}
