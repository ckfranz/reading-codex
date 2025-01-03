//
//  BooksViewModel.swift
//  WOT Characters
//
//  Created by Curtis Franz on 2024-12-23.
//

import SwiftUI

class BooksViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var dominantColors: [String: Color] = [:] // Map book IDs to colors
    
    
    init() {
        loadBooks()
    }
    
    private func loadBooks() {
        books = [
                    Book(id: "book-00", name: "New Spring", bookNumber: "Prequel", fileName: "book-00", artworkName: "Wheel-of-Time-DKS-New-Spring", coverName: "cover0"),
                    Book(id: "book-01", name: "The Eye of the World", bookNumber: "Book 1", fileName: "book-01", artworkName: "Wheel-of-Time-DKS-Eye-of-the-World", coverName: "cover1"),
                    Book(id: "book-02", name: "The Great Hunt", bookNumber: "Book 2", fileName: "book-02", artworkName: "Wheel-of-Time-DKS-Great-Hunt", coverName: "cover2"),
                    Book(id: "book-03", name: "The Dragon Reborn", bookNumber: "Book 3", fileName: "book-03", artworkName: "Wheel-of-Time-DKS-Dragon-Reborn", coverName: "cover3"),
                    Book(id: "book-04", name: "The Shadow Rising", bookNumber: "Book 4", fileName: "book-04", artworkName: "Wheel-of-Time-DKS-Shadow-Rising", coverName: "cover4"),
                    Book(id: "book-05", name: "The Fires of Heaven", bookNumber: "Book 5", fileName: "book-05", artworkName: "Wheel-of-Time-DKS-Fires-of-Heaven", coverName: "cover5"),
                    Book(id: "book-06", name: "Lord of Chaos", bookNumber: "Book 6", fileName: "book-06", artworkName: "Wheel-of-Time-DKS-Lord-of-Chaos", coverName: "cover6"),
                    Book(id: "book-07", name: "A Crown of Swords", bookNumber: "Book 7", fileName: "book-07", artworkName: "Wheel-of-Time-DKS-Crown-of-Swords", coverName: "cover7"),
                    Book(id: "book-08", name: "The Path of Daggers", bookNumber: "Book 8", fileName: "book-08", artworkName: "Wheel-of-Time-DKS-Path-of-Daggers", coverName: "cover8"),
                    Book(id: "book-09", name: "Winter's Heart", bookNumber: "Book 9", fileName: "book-09", artworkName: "Wheel-of-Time-DKS-Winters-Heart", coverName: "cover9"),
                    Book(id: "book-10", name: "Crossroads of Twilight", bookNumber: "Book 10", fileName: "book-10", artworkName: "Wheel-of-Time-DKS-Crossroads-of-Twilight", coverName: "cover10"),
                    Book(id: "book-11", name: "Knife of Dreams", bookNumber: "Book 11", fileName: "book-11", artworkName: "Wheel-of-Time-DKS-Knife-of-Dreams", coverName: "cover11"),
                    Book(id: "book-12", name: "The Gathering Storm", bookNumber: "Book 12", fileName: "book-12", artworkName: "Wheel-of-Time-DKS-Gathering-Storm", coverName: "cover12"),
                    Book(id: "book-13", name: "Towers of Midnight", bookNumber: "Book 13", fileName: "book-13", artworkName: "Wheel-of-Time-DKS-Towers-of-Midnight", coverName: "cover13"),
                    Book(id: "book-14", name: "A Memory of Light", bookNumber: "Book 14", fileName: "book-14", artworkName: "Wheel-of-Time-MW-Memory-of-Light", coverName: "cover14")
                ]
    }
}

struct Book: Identifiable, Hashable {
    let id: String
    let name: String
    let bookNumber: String
    let fileName: String
    let artworkName: String
    let coverName: String
    var dominantColor: Color?
}
