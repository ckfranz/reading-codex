//
//  BookSummaryView.swift
//  WOT Characters
//
//  Created by Curtis Franz on 2024-12-25.
//

import SwiftUI
import Foundation
import UIKit

@available(iOS 16.0, *)
struct BookSummaryView: View {
    let bookSummary: BookSummary
    let artworkName: String

    var dominantColor: Color {
        if let artwork = UIImage(named: artworkName),
           let color = artwork.dominantColor() {
            return Color(uiColor: color)
        }
        return Color.gray
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Summary details
                Text("Author: \(bookSummary.author)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .italic()
                Text("Summary")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.top, 8)
                ForEach(bookSummary.summary) { section in
                    VStack(alignment: .leading, spacing: 16) {
                        if section.section != "Summary" {
                            Text(section.section)
                                .font(.headline)
                        }
                        // Split content into paragraphs and add spacing between them
                        ForEach(section.content.split(separator: "\n", omittingEmptySubsequences: false), id: \.self) { paragraph in
                            Text(paragraph)
                                .font(.body)
                                .padding(.bottom, paragraph.isEmpty ? 0 : 4)
                        }
                    }
                    .padding(.horizontal)
                }
                Link("Source: library.tarvalon.net", destination: URL(string: "https://library.tarvalon.net/index.php?title=Book_Summaries")!)
                    .font(.footnote)
                    .padding()
                    .underline()
                    .foregroundColor(.gray)
                    .tint(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Book Summary")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension Color {
    init(uiColor: UIColor) {
        self.init(uiColor)
    }
}

extension UIImage {
    func dominantColor() -> UIColor? {
        guard let cgImage = self.cgImage else { return nil }

        let width = 1
        let height = 1
        let bitsPerComponent = 8
        let bytesPerRow = width * 4
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let rawData = UnsafeMutablePointer<UInt8>.allocate(capacity: width * height * 4)
        defer { rawData.deallocate() }
        
        guard let context = CGContext(data: rawData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil
        }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        let red = CGFloat(rawData[0]) / 255.0
        let green = CGFloat(rawData[1]) / 255.0
        let blue = CGFloat(rawData[2]) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

struct BookSummary: Identifiable, Decodable {
    let id = UUID()
    let title: String
    let author: String
    let summary: [SummarySection]
}

struct SummarySection: Identifiable, Decodable {
    let id = UUID()
    let section: String
    let content: String
}
