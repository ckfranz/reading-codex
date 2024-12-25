import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    let allCharacters: [Character] // Pass all characters to resolve links
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(character.name)
                    .font(.largeTitle)
                    .bold()
                
                Text(character.chapter)
                    .font(.headline)
                    .padding(.top)
                
                infoTextView
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var infoTextView: some View {
        let components = parseInfo(character.info)
        return VStack(alignment: .leading, spacing: 8) {
            ForEach(components, id: \.self) { component in
                if let linkedCharacter = component.linkedCharacter {
                    NavigationLink(destination: CharacterDetailView(character: linkedCharacter, allCharacters: allCharacters)) {
                        Text(component.text)
                            .foregroundColor(.blue)
                            
                    }
                } else {
                    Text(component.text)
                }
            }
        }
    }
    
    private func parseInfo(_ info: String) -> [InfoComponent] {
        var components: [InfoComponent] = []
        let regex = try! NSRegularExpression(pattern: #"\[(.*?)\]\(#(.*?)\)"#, options: [])
        let matches = regex.matches(in: info, options: [], range: NSRange(location: 0, length: info.utf16.count))
        
        var currentIndex = info.startIndex
        for match in matches {
            if let range = Range(match.range(at: 0), in: info) {
                // Add plain text before the match
                let beforeText = String(info[currentIndex..<range.lowerBound])
                if !beforeText.isEmpty {
                    components.append(InfoComponent(text: beforeText))
                }
                
                // Add linked text
                if let nameRange = Range(match.range(at: 1), in: info),
                   let idRange = Range(match.range(at: 2), in: info) {
                    let name = String(info[nameRange])
                    let id = String(info[idRange])
                    let linkedCharacter = allCharacters.first { $0.id == id }
                    components.append(InfoComponent(text: name, linkedCharacter: linkedCharacter))
                }
                
                // Update the current index
                currentIndex = range.upperBound
            }
        }
        
        // Add any remaining plain text
        if currentIndex < info.endIndex {
            components.append(InfoComponent(text: String(info[currentIndex...])))
        }
        
        return components
    }
}

// Helper struct to handle parsed text
struct InfoComponent: Hashable {
    let text: String
    let linkedCharacter: Character?

    init(text: String, linkedCharacter: Character? = nil) {
        self.text = text
        self.linkedCharacter = linkedCharacter
    }
    
    // Conformance to Equatable (automatically handled by Hashable in modern Swift)
    static func == (lhs: InfoComponent, rhs: InfoComponent) -> Bool {
        return lhs.text == rhs.text && lhs.linkedCharacter?.id == rhs.linkedCharacter?.id
    }
    
    // Conformance to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(linkedCharacter?.id) // Use `id` to uniquely identify linkedCharacter
    }
}
