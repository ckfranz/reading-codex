//
//  ChapterSummaryView.swift
//  WOT Characters
//
//  Created by Curtis Franz on 2024-12-28.
//

import SwiftUI

@available(iOS 16.0, *)
struct BookChaptersView: View {
    let bookChapters: BookChapters
    @State private var selectedChapter: ChapterSummary?
    @State private var expandedChapters: Set<String> = []
    @State private var showChapterSelector: Bool = false
    @State private var expandedHeights: [String: CGFloat] = [:]

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(bookChapters.chapters, id: \.chapter) { chapter in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    if let iconName = chapter.icon, let uiImage = UIImage(named: iconName) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 40, height: 35)
                                            .padding(.trailing, 8)
                                    } else {
                                        Image(uiImage: UIImage(named: "Wheel-icon")!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 40, height: 35)
                                            .padding(.trailing, 8)
                                    }
//                                    // Chapter Details
//                                    VStack(alignment: .leading, spacing: 4) {
//                                        Text(chapter.chapter)
//                                            .font(.headline)
//                                            .foregroundColor(.primary)
//                                        Text(chapter.name)
//                                            .font(.subheadline)
//                                            .foregroundColor(.secondary)
//                                    }
                                    
                                    Text(chapter.chapter)
                                        .font(.headline)
                                    Text(chapter.name)
                                        .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.gray)
                                    Spacer()
                                    Button(action: {
                                        toggleExpansion(for: chapter)
                                    }) {
                                        Image(systemName: expandedChapters.contains(chapter.chapter) ? "chevron.down" : "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    toggleExpansion(for: chapter)
                                }

                                if expandedChapters.contains(chapter.chapter) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        // Author Section
                                        Text("Author: \(chapter.author)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .italic() // Italicizes the author's name
                                            .padding(.top, 8)
                                            .foregroundColor(.secondary)
                                        // Overview Header and Text
                                        
                                        if !chapter.summary.outline.isEmpty {
                                            Text("Overview")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .padding(.bottom, 4)
                                            ForEach(chapter.summary.outline.split(separator: "\n", omittingEmptySubsequences: false), id: \.self) { paragraph in
                                                Text(paragraph)
                                                    .font(.body)
                                                    .foregroundColor(.primary)
                                                    .padding(.bottom, paragraph.isEmpty ? 0 : 4)
                                            }
                                        }
                                        // Summaries Header
                                                if !chapter.summary.summary.isEmpty {
                                                    Text("Summary")
                                                        .font(.title2)
                                                        .fontWeight(.bold)
                                                        .padding(.top, 8)
                                                    // Point of View Summaries
                                                    ForEach(chapter.summary.summary, id: \.povCharacter) { pov in
                                                        if pov.povCharacter != "General" { // Skip displaying "General"
                                                            VStack(alignment: .leading, spacing: 4) {
                                                                Text("Point of View: \(pov.povCharacter)")
                                                                    .font(.subheadline)
                                                                    .foregroundColor(.secondary)
                                                                    .padding(.bottom, 2)
                                                                
                                                                // Display the Setting if available
                                                                if let setting = pov.setting, !setting.isEmpty {
                                                                    Text("Setting: \(setting)")
                                                                        .font(.subheadline)
                                                                        .foregroundColor(.secondary)
                                                                        .padding(.bottom, 4)
                                                                }
                                                                
                                                                // Display the Summary with gaps between paragraphs
                                                                VStack(alignment: .leading, spacing: 8) { // Adjust `spacing` for the gap size
                                                                    ForEach(pov.povSummary.split(separator: "\n", omittingEmptySubsequences: false), id: \.self) { paragraph in
                                                                        Text(paragraph)
                                                                            .font(.body)
                                                                            .padding(.bottom, paragraph.isEmpty ? 0 : 4)
                                                                    }
                                                                }
                                                                .padding(.bottom, 4)
                                                            }.padding(.top, 8)
                                                        } else {
                                                            // General Summary with gaps between paragraphs
                                                            VStack(alignment: .leading, spacing: 8) { // Adjust `spacing` for the gap size
                                                                ForEach(pov.povSummary.split(separator: "\n", omittingEmptySubsequences: false), id: \.self) { paragraph in
                                                                    Text(paragraph)
                                                                        .font(.body)
                                                                        .padding(.bottom, paragraph.isEmpty ? 0 : 4)
                                                                }
                                                            }
                                                            .padding(.bottom, 4)
                                                        }
                                                    }
                                                        
                                                }
                                        
                                        
                                    }.padding(.top, 16)
                                        .background(
                                            GeometryReader { geometry in
                                                Color.clear.preference(key: HeightPreferenceKey.self, value: geometry.size.height)
                                            }
                                        )
                                        .clipped()
                                }
                            }
                            .padding(.vertical, 8)
                            .id(chapter.chapter)
                            .animation(.easeInOut, value: expandedChapters)
                            .onPreferenceChange(HeightPreferenceKey.self) { height in
                                expandedHeights[chapter.chapter] = expandedChapters.contains(chapter.chapter) ? height : 0
                            }
                        }
                        Link("Source: library.tarvalon.net", destination: URL(string: "https://library.tarvalon.net/index.php?title=Chapter_Summaries")!)
                            .font(.footnote)
                            .padding()
                            .underline()
                            .foregroundColor(.gray)
                            .tint(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding()
                }

                // Automatically scroll to selected chapter if any
//                .onChange(of: selectedChapter) { newChapter in
//                    if let selectedChapter = newChapter {
//                        withAnimation {
//                            proxy.scrollTo(selectedChapter.chapter, anchor: .top)
//                        }
//                    }
//                }
            }

//            Spacer()

//            Button(action: {
//                showChapterSelector = true
//            }) {
//                Text("Select Chapter")
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding()
//            .opacity(bookChapters.chapters.count > 1 ? 1 : 0) // Show only if there are multiple chapters
        }
        .navigationTitle(bookChapters.title)
        .sheet(isPresented: $showChapterSelector) {
            ChapterSelectorView(
                chapters: bookChapters.chapters,
                onChapterSelected: { chapter in
                    selectedChapter = chapter
                    toggleExpansion(for: chapter) // Automatically expand the selected chapter
                    showChapterSelector = false
                }
            )
        }
    }

    // Toggles the expansion state for a chapter
    private func toggleExpansion(for chapter: ChapterSummary) {
        if expandedChapters.contains(chapter.chapter) {
            expandedChapters.remove(chapter.chapter)
        } else {
            expandedChapters.insert(chapter.chapter)
        }
    }
}

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

@available(iOS 16.0, *)
struct ChapterSelectorView: View {
    let chapters: [ChapterSummary]
    var onChapterSelected: (ChapterSummary) -> Void

    var body: some View {
        NavigationView {
            List(chapters, id: \.chapter) { chapter in
                Button(action: {
                    onChapterSelected(chapter)
                }) {
                    HStack {
                        Text(chapter.chapter)
                            .font(.headline)
                        Spacer()
                        Text(chapter.name)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Select a Chapter")
            .navigationBarItems(trailing: Button("Close") {
                onChapterSelected(chapters.first!)
            })
        }
    }
}


struct ChapterSummary: Codable {
    let chapter: String
    let name: String
    let author: String
    let icon: String?
    let summary: ChapterSummaryContent
}

struct ChapterSummaryContent: Codable {
    let summary: [POVSummary]
    let outline: String
    
    enum CodingKeys: String, CodingKey {
        case summary = "Summary"
        case outline = "Outline"
    }
}

struct POVSummary: Codable {
    let povCharacter: String
    let povSummary: String
    let setting: String?
    
    enum CodingKeys: String, CodingKey {
        case povCharacter = "pov_character"
        case povSummary = "pov_summary"
        case setting = "setting"
    }
}


struct BookChapters: Codable {
    let title: String
    let chapters: [ChapterSummary]
    
    private enum CodingKeys: String, CodingKey {
        case title
        case chapters = "content"
    }
}
