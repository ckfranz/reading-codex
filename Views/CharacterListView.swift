//
//  CharacterListView.swift
//  WOT Characters
//
//  Created by Curtis Franz on 2024-12-23.
//

import SwiftUI

// Character list view
@available(iOS 16.0, *)
struct CharacterListView: View {
    let book: Book
    @ObservedObject var charactersViewModel: CharactersViewModel
    @EnvironmentObject var router: AppRouter

    @State private var searchText = ""

    var filteredCharacters: [Character] {
        if searchText.isEmpty {
            return charactersViewModel.characters
        } else {
            return charactersViewModel.characters.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    // Group characters alphabetically by their first letter
    var groupedCharacters: [String: [Character]] {
        Dictionary(grouping: filteredCharacters) { character in
            String(character.name.prefix(1)).uppercased()
        }
    }

    var sortedSections: [String] {
        groupedCharacters.keys.sorted()
    }

    var body: some View {
        VStack {
            // Search Bar with Character Count
            VStack {
                SearchBar(searchText: $searchText, isSearching: .constant(false))
                HStack {
                    Text("Characters: \(filteredCharacters.count)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.horizontal)
            }

            if filteredCharacters.isEmpty {
                Text("No characters found")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(sortedSections, id: \.self) { section in
                        Section(header: Text(section).padding(.vertical, 0)) {
                            ForEach(groupedCharacters[section] ?? []) { character in
                                HStack {
                                    Text(character.name)
                                        .padding(.vertical, 4)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .contentShape(Rectangle()) // Makes the entire row tappable
                                .onTapGesture {
                                    router.navigateToCharacter(character)
                                    router.allCharacters = charactersViewModel.characters
                                }
                            }
                        }
                    }
                }.ignoresSafeArea(.container, edges: [])
                .listStyle(.insetGrouped)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
        }
        .navigationTitle(book.name)
        .onAppear {
            charactersViewModel.loadCharacters(from: book.fileName)
        }.ignoresSafeArea(.container, edges: [])
    }
}

@available(iOS 16.0, *)
struct CharacterListViewWithDropdown: View {
    @ObservedObject var booksViewModel: BooksViewModel
    @State private var selectedBook: Book? // Tracks the currently selected book
    @StateObject private var charactersViewModel = CharactersViewModel() // Shared ViewModel
    @EnvironmentObject var router: AppRouter
    var body: some View {
        VStack {
            // Book Selection Dropdown
            Picker("Select a Book", selection: $selectedBook) {
                Text("All Characters").tag(nil as Book?) // Special "All Characters" option
                ForEach(booksViewModel.books) { book in
                    Text(book.name).tag(book as Book?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .onChange(of: selectedBook) { newBook in
                if newBook == nil {
                    // Load all unique characters
                    charactersViewModel.loadAllCharacters(from: booksViewModel.books)
                } else if let book = newBook {
                    // Load characters from the selected book
                    charactersViewModel.loadCharacters(from: book.fileName)
                }
            }

            // Show Character List or Placeholder
            if selectedBook == nil && charactersViewModel.characters.isEmpty {
                Text("Please select a book to view characters.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                CharacterListView(
                    book: selectedBook ?? Book(id: "book-0", name: "All Characters", bookNumber: "", fileName: "", artworkName: "", coverName: ""),
                    charactersViewModel: charactersViewModel
                )
            }
        }.ignoresSafeArea(.container, edges: [])
        .navigationTitle("Characters")
        .onAppear {
            // Set a default book if none is selected
            if selectedBook == nil {
                if let defaultBook = booksViewModel.books.first(where: { $0.id == "book-01" }) {
                    selectedBook = defaultBook // Default to the first book in the list
                    charactersViewModel.loadCharacters(from: defaultBook.fileName)
                } else {
                    charactersViewModel.loadAllCharacters(from: booksViewModel.books)
                }
            }
        }
    }
}
