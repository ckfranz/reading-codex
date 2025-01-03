//
//  WOT_CharactersApp.swift
//  WOT Characters
//
//  Created by Curtis Franz on 2021-02-08.
//

import SwiftUI

@available(iOS 16.0, *)
@main
struct WOTCharactersApp: App {
    @ObservedObject var router = AppRouter()
    @State private var selectedBook: Book? // Tracks the currently selected book
    
    var summaryData = SummaryData()
    @State private var isUIHidden: Bool = false // Track if UI should be hidden

    var body: some Scene {
        WindowGroup {
            ZStack {
                if !isUIHidden {
                    TabView {
                        BookSelectionView()
                            .tabItem {
                                Image(systemName: "books.vertical.fill")
                                Text("Books")
                            }
                            .environmentObject(summaryData)

                        NavigationStack(path: $router.path) {
                            CharacterListViewWithDropdown(
                                booksViewModel: BooksViewModel()
                            )
                            .navigationDestination(for: AppRoute.self) { route in
                                switch route {
                                case .book(let book):
                                    BookDetailView(book: book)
                                case .characterList(let book):
                                    CharacterListView(
                                        book: book,
                                        charactersViewModel: CharactersViewModel()
                                    )
                                case .character(let character):
                                    CharacterDetailView(character: character, allCharacters: router.allCharacters)
                                }
                            }
                            .navigationTitle("") // Removes the title
                            .toolbar(.hidden, for: .navigationBar) // Hides the navigation bar
                        }
                        .environmentObject(router)
                        .tabItem {
                            Image(systemName: "person.3.fill")
                            Text("Characters")
                        }
                    
                        MapView(isUIHidden: $isUIHidden)
                            .tabItem {
                                Image(systemName: "map.fill")
                                Text("Map")
                            }
                    }
                } else {
                    // This is where you can display the MapView full-screen without the TabView
                    MapView(isUIHidden: $isUIHidden)
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
}
