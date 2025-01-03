//
//  ContentView.swift
//  WOT Characters
//
//  Created by Curtis Franz on 2021-02-08.
//

import SwiftUI

@available(iOS 16.0, *)
struct ContentView: View {
    @StateObject private var router = AppRouter()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            BookSelectionView()
                .navigationDestination(for: Book.self) { book in
                    BookDetailView(book: book)
                }
                .navigationDestination(for: Book.self) { book in
                    CharacterListView(book: book, charactersViewModel: CharactersViewModel())
                }
                .navigationDestination(for: Character.self) { character in
                    CharacterDetailView(character: character, allCharacters: router.allCharacters)
                }
        }
        .environmentObject(router) // Provide the router to the environment
    }
}

@available(iOS 16.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .colorScheme(.light)
        ContentView()
            .colorScheme(.dark)
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool

    var body: some View {
        HStack {
            HStack {
                TextField("Search characters here", text: $searchText)
                    .padding(.leading, 24)
                    .onTapGesture {
                        isSearching = true
                    }
            }
            .padding()
            .frame(height:34) // Adjust the height here
            .background(Color(.systemGray5))
            .cornerRadius(6)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading, 8)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }
            )
            .padding(.horizontal)

            if isSearching {
                Button(action: {
                    isSearching = false
                    searchText = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                        .padding(.trailing, 8)
                }
                .transition(.move(edge: .trailing))
                .animation(.spring(), value: isSearching)
            }
        }
    }
}
