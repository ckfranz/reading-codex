//
//  CharacterListView.swift
//  WOT Characters
//
//  Created by Curtis Franz on 2024-12-23.
//

import SwiftUI

// Character list view
struct CharacterListView: View {
    let book: Book
    @ObservedObject var charactersViewModel: CharactersViewModel
    @State private var searchText = ""
    
    var filteredCharacters: [Character] {
        if searchText.isEmpty {
            return charactersViewModel.characters
        } else {
            return charactersViewModel.characters.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack {
            SearchBar(searchText: $searchText, isSearching: .constant(false))
            
            if filteredCharacters.isEmpty {
                Text("No characters found")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(filteredCharacters) { character in
                    NavigationLink(destination: CharacterDetailView(character: character)) {
                        Text(character.name)
                    }
                }
            }
        }
        .navigationTitle(book.name)
        .onAppear {
            charactersViewModel.loadCharacters(from: book.fileName)
        }
    }
}
