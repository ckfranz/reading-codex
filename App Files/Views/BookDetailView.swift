//
//  BookDetailView.swift
//  WOT Characters
//
//  Created by Curtis Franz on 2024-12-25.
//

import SwiftUI

import Foundation

class SummaryLoader {
    static func loadSummaries() -> [BookSummary] {
        guard let url = Bundle.main.url(forResource: "book_summaries", withExtension: "json") else {
            print("Failed to locate summaries.json in the bundle.")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let summaries = try JSONDecoder().decode([BookSummary].self, from: data)
            return summaries
        } catch {
            print("Failed to decode summaries.json: \(error.localizedDescription)")
            return []
        }
    }
}

class ChapterSummaryLoader {
    static func loadChapterSummaries() -> [BookChapters] {
        guard let url = Bundle.main.url(forResource: "chapter_summaries", withExtension: "json") else {
            print("Failed to locate chapters.json in the bundle.")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let chapters = try JSONDecoder().decode([BookChapters].self, from: data)

            return chapters
        } catch {
            print("Failed to decode chapters.json: \(error.localizedDescription)")
            return []
        }
    }
}


@available(iOS 16.0, *)
struct BookDetailView: View {
    let book: Book
    
    @EnvironmentObject var router: AppRouter

    @State private var bookSummaries: [BookSummary] = []
    @State private var chapterSummaries: [BookChapters] = []


    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                VStack {
                    Text(book.name)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                }
                .padding()
            }
            NavigationLink(destination: {
                if let summary = bookSummaries.first(where: { $0.title == book.name }) {
                    BookSummaryView(bookSummary: summary, artworkName: book.artworkName)
                } else {
                    Text("Summary not available.")
                        .font(.body)
                        .padding()
                }
            }) {
                Text("Book Summary")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .onAppear {
                    bookSummaries = SummaryLoader.loadSummaries()
                }
//            NavigationLink(destination: { CharacterByChapterView(viewModel: CharactersViewModel(), book: book)
//                Text("Filter by Chapters")
//            }) {
//                Text("Book Summary")
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                }
//                .onAppear {
//                    bookSummaries = SummaryLoader.loadSummaries()
//                }
            
            NavigationLink(destination: {
                            if let bookChapters = chapterSummaries.first(where: { $0.title == book.name }) {
                                BookChaptersView(bookChapters: bookChapters)
                            } else {
                                Text("Chapter summaries not available.")
                                    .font(.body)
                                    .padding()
                            }
                        }) {
                            Text("Chapter Summaries")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .onAppear {
                            chapterSummaries = ChapterSummaryLoader.loadChapterSummaries()
                        }
                Button(action: {
                    router.navigateToCharacterList(book)
                }) {
                    Text("Characters")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            
                .onAppear {
                    bookSummaries = SummaryLoader.loadSummaries()
                }
            
            
            Spacer()
        }
        .padding()
        .navigationTitle("Book Details")
    }
}
