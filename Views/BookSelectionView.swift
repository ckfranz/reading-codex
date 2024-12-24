//
//  BookSelectionView.swift
//  WOT Characters
//
//  Created by Curtis Franz on 2024-12-23.
//

import SwiftUI

struct BookSelectionView: View {
    @ObservedObject var booksViewModel = BooksViewModel()
    
    var body: some View {
        NavigationView {
            List(booksViewModel.books) { book in
                NavigationLink(destination: CharacterListView(book: book, charactersViewModel: CharactersViewModel())) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(book.name)
                            .font(.headline)
                        Text(book.bookNumber)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Select a Book")
        }
    }
}
