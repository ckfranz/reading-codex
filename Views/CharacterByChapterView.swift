//
//  CharacterByChapterView.swift
//  WOT Characters
//
//  Created by Curtis Franz on 2024-12-29.
//

import SwiftUI

@available(iOS 16.0, *)
struct CharacterByChapterView: View {
    @ObservedObject var viewModel: CharactersViewModel
    let book: Book

    
    var groupedByChapters: [String: [Character]] {
        Dictionary(grouping: viewModel.characters) { character in
            character.chapters.joined(separator: ", ")
        }
    }

    var sortedChapters: [String] {
        groupedByChapters.keys.sorted()
    }

    @State private var expandedChapters: Set<String> = []

    var body: some View {
        NavigationView {
            List {
                ForEach(sortedChapters, id: \.self) { chapter in
                    DisclosureGroup(
                        isExpanded: Binding(
                            get: { expandedChapters.contains(chapter) },
                            set: { isExpanded in
                                if isExpanded {
                                    expandedChapters.insert(chapter)
                                } else {
                                    expandedChapters.remove(chapter)
                                }
                            }
                        )
                    ) {
                        ForEach(groupedByChapters[chapter] ?? []) { character in
                            NavigationLink(destination: CharacterDetailView(character: character, allCharacters: viewModel.characters)) {
                                Text(character.name)
                            }
                        }
                    } label: {
                        Text(chapter)
                            .font(.headline)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Characters by Chapter")
        }.onAppear {
            if viewModel.characters.isEmpty {
                viewModel.loadCharacters(from: book.fileName)
            }
        }
    }
}
