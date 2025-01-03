//
//  BookDetailSheet.swift
//  WOT Characters
//
//  Created by Curtis Franz on 2024-12-31.
//

import SwiftUI

final class SummaryData: ObservableObject {
    @Published var chapterSummaries: [BookChapters] = []
    @Published var bookSummaries: [BookSummary] = []
    
}

@available(iOS 16.0, *)
struct BookDetailSheetView: View {
    let book: Book
    let artworkName: String
    @EnvironmentObject var summaryData: SummaryData

    @State private var selectedView: DisplayView = .chapters

    enum DisplayView: String, CaseIterable {
        case chapters = "Chapter Recaps"
        case summary = "Book Summary"
    }

    var body: some View {
        VStack {
            //dominantColor
            //     .edgesIgnoringSafeArea(.top) // Bleed effect
            ZStack {
                if let artwork = UIImage(named: artworkName) {
                    Image(uiImage: artwork)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 150)
                        .clipped()
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                } else {
                    Color.gray
                        .frame(height: 150)
                }
                // Title overlay
                VStack {
                    Text(book.name)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    Text(book.bookNumber)
                        .font(.subheadline)
                        .shadow(radius: 5)
                        .foregroundColor(.white)
                }
                .padding()
            }
            // Picker for switching views
            Picker("Select View", selection: $selectedView) {
                ForEach(DisplayView.allCases, id: \.self) { view in
                    Text(view.rawValue).tag(view)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            Divider()

            // Display the selected view
            switch selectedView {
            case .summary:
                if let summary = summaryData.bookSummaries.first(where: { $0.title == book.name }) {
                    BookSummaryView(bookSummary: summary, artworkName: book.artworkName)
                } else {
                    Text("Summary not available.")
                        .font(.body)
                        .padding()
                }

            case .chapters:
                if let chapters = summaryData.chapterSummaries.first(where: { $0.title == book.name }) {
                    BookChaptersView(bookChapters: chapters)
                    
                } else {
                    Text("Chapter summaries not available.")
                        .font(.body)
                        .padding()
                }
            }
        }.frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
//            print("Book Summaries: \(bookSummaries)")
//            print("Chapter Summaries: \(chapterSummaries)")
        }
        .presentationDetents([.large, .large])
        .presentationDragIndicator(.visible)
    }
}

//extension Color {
//    init(uiColor: UIColor) {
//        self.init(uiColor)
//    }
//}
//
//extension UIImage {
//    func dominantColor() -> UIColor? {
//        guard let cgImage = self.cgImage else { return nil }
//
//        let width = 1
//        let height = 1
//        let bitsPerComponent = 8
//        let bytesPerRow = width * 4
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let rawData = UnsafeMutablePointer<UInt8>.allocate(capacity: width * height * 4)
//        defer { rawData.deallocate() }
//        
//        guard let context = CGContext(data: rawData,
//                                      width: width,
//                                      height: height,
//                                      bitsPerComponent: bitsPerComponent,
//                                      bytesPerRow: bytesPerRow,
//                                      space: colorSpace,
//                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
//            return nil
//        }
//
//        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
//
//        let red = CGFloat(rawData[0]) / 255.0
//        let green = CGFloat(rawData[1]) / 255.0
//        let blue = CGFloat(rawData[2]) / 255.0
//
//        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
//    }
//}
//
//struct BookSummary: Identifiable, Decodable {
//    let id = UUID()
//    let title: String
//    let author: String
//    let summary: [SummarySection]
//}
//
//struct SummarySection: Identifiable, Decodable {
//    let id = UUID() // Optional but useful for identifying the sections uniquely
//    let section: String
//    let content: String
//}
