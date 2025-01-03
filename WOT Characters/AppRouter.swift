//
//  AppRouter.swift
//  WOT Characters
//
//  Created by Curtis Franz on 2024-12-27.
//

import SwiftUI

final class AppRouter: ObservableObject {

    @Published var path: [AppRoute] = []
    @Published var currentBook: Book? = nil

    var allCharacters: [Character] = []
    
    func navigateToCharacter(_ character: Character) {
        // Avoid adding duplicate entries for the same character
        if path.last != .character(character) {
            path.append(.character(character))
        }
    }

    func navigateToBook(_ book: Book) {
        path.append(.book(book))
    }
    
    func navigateToCharacterList(_ book: Book) {
        path.append(.characterList(book))
    }
    
    func goBack() {
        _ = path.popLast()
    }
}
enum AppRoute: Hashable {
    case book(Book)
    case character(Character)
    case characterList(Book)
}

// Data for navigating to `CharacterListView`
struct CharacterListNavigationData: Hashable {
    let book: Book
}
