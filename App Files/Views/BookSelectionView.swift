import UIKit
import SwiftUI

@available(iOS 16.0, *)
struct BookSelectionView: View {
    @ObservedObject var booksViewModel = BooksViewModel()
    @State private var bookmarkedBookID: String? // Tracks the bookmarked book ID
    @State private var selectedBook: Book? = nil // Track selected book for sheet presentation
    @State private var isSheetPresented = false
    @EnvironmentObject var summaryData: SummaryData

    @State private var bookSummaries: [BookSummary] = []
    @State private var chapterSummaries: [BookChapters] = []
    
    @EnvironmentObject var router: AppRouter

    var body: some View {
        NavigationView {
            List {
                
//                // Display the bookmarked book at the top
//                if let bookmarkedBook = getBookmarkedBook() {
////                    Section(header: Text("Bookmarked")) {
//                        bookFeature(for: bookmarkedBook).listRowBackground(Color.clear) // Clear the background
//
////                    }
//                }

                // Dropdown for non-bookmarked books
                Section {
//                    DisclosureGroup(
//                        isExpanded: $isDropdownExpanded,
//                        content: {
//                            ForEach(booksViewModel.books.filter { $0.id != bookmarkedBookID }) { book in
                                ForEach(booksViewModel.books) { book in

                                bookRow(for: book)
                            }
//                        },
//                        label: {
//                            Text("Select a Book")
//                                .font(.headline)
//                                .foregroundColor(.blue)
//                        }
//                    )
                }
            }
            .onAppear {
                summaryData.bookSummaries = SummaryLoader.loadSummaries()
                summaryData.chapterSummaries = ChapterSummaryLoader.loadChapterSummaries()
            }
            .navigationTitle("Select a Book")
        }
        
        .sheet(item: $selectedBook) { book in
            // Sheet content for selected book
            BookDetailSheetView(
                book: book,
                artworkName: book.artworkName
            ).environmentObject(summaryData)
        }

    }

    private func bookRow(for book: Book) -> some View {
        HStack(spacing: 12) {
            Image(book.coverName)
                .resizable()
                .scaledToFill()
                .frame(width: 38, height: 60)
                .cornerRadius(4)

            VStack(alignment: .leading) {
                Text(book.name).font(.headline)
                Text(book.bookNumber).font(.subheadline).foregroundColor(.gray)
            }

            Spacer()

            Button(action: {
                toggleBookmark(for: book)
            }) {
                Image(systemName: bookmarkedBookID == book.id ? "bookmark.fill" : "bookmark")
                    .foregroundColor(.red)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .contentShape(Rectangle())
        .onTapGesture {
            // Trigger sheet presentation
            if selectedBook == nil {
                selectedBook = book
            }
        }
    }

    //    private func bookFeature(for book: Book) -> some View {
    //        VStack(alignment: .leading) {
    //            HStack(spacing: 12) {
    //                Spacer()
    //                Image(book.coverName)
    //                    .resizable()
    //                    .scaledToFill()
    //                    .frame(width: 72, height: 120)
    //                    .cornerRadius(4)
    //                Spacer()
    //            }
    //            VStack(alignment: .leading) {
    //                Text(book.name).font(.headline).multilineTextAlignment(.center)
    //                Text(book.bookNumber).font(.subheadline).foregroundColor(.gray).multilineTextAlignment(.center)
    //            }
    //            .frame(maxWidth: .infinity, alignment: .center)
    //            .contentShape(Rectangle())
    //            .onTapGesture {
    //                let _ = print(book.id)
    //                if let index = booksViewModel.books.firstIndex(where: { $0.id == book.id }) {
    //                    selectedBookIndex = index
    //                    isSheetPresented = true
    //                }
    //            }
    //            .listRowBackground(Color.clear) // Clear the background
    //        }
    //    }
    
    private func toggleBookmark(for book: Book) {
        if bookmarkedBookID == book.id {
            bookmarkedBookID = nil
        } else {
            bookmarkedBookID = book.id
        }
    }
    
//    private func getBookmarkedBook() -> Book? {
//        return booksViewModel.books.first { $0.id == bookmarkedBookID }
//    }
}
