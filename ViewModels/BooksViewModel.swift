//
//  BooksViewModel.swift
//  WOT Characters
//
//  Created by Curtis Franz on 2024-12-23.
//

import SwiftUI

class BooksViewModel: ObservableObject {
    @Published var books: [Book] = []
    
    init() {
        loadBooks()
    }
    
    private func loadBooks() {
        books = [
                    Book(id: "book-00", name: "New Spring", bookNumber: "Book 00", fileName: "book-00"),
                    Book(id: "book-01", name: "The Eye of the World", bookNumber: "Book 01", fileName: "book-01"),
                    Book(id: "book-02", name: "The Great Hunt", bookNumber: "Book 02", fileName: "book-02"),
                    Book(id: "book-03", name: "The Dragon Reborn", bookNumber: "Book 03", fileName: "book-03"),
                    Book(id: "book-04", name: "The Shadow Rising", bookNumber: "Book 04", fileName: "book-04"),
                    Book(id: "book-05", name: "The Fires of Heaven", bookNumber: "Book 05", fileName: "book-05"),
                    Book(id: "book-06", name: "Lord of Chaos", bookNumber: "Book 06", fileName: "book-06"),
                    Book(id: "book-07", name: "A Crown of Swords", bookNumber: "Book 07", fileName: "book-07"),
                    Book(id: "book-08", name: "The Path of Daggers", bookNumber: "Book 08", fileName: "book-08"),
                    Book(id: "book-09", name: "Winter's Heart", bookNumber: "Book 09", fileName: "book-09"),
                    Book(id: "book-10", name: "Crossroads of Twilight", bookNumber: "Book 10", fileName: "book-10"),
                    Book(id: "book-11", name: "Knife of Dreams", bookNumber: "Book 11", fileName: "book-11"),
                    Book(id: "book-12", name: "The Gathering Storm", bookNumber: "Book 12", fileName: "book-12"),
                    Book(id: "book-13", name: "Towers of Midnight", bookNumber: "Book 13", fileName: "book-13"),
                    Book(id: "book-14", name: "A Memory of Light", bookNumber: "Book 14", fileName: "book-14")
                ]
    }
}

struct Book: Identifiable {
    let id: String
    let name: String
    let bookNumber: String
    let fileName: String
}
