import SwiftUI

@available(iOS 15.0, *)
struct CharacterDetailView: View {
    let character: Character
    let allCharacters: [Character] // Pass all characters to resolve links
    @EnvironmentObject var router: AppRouter

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(character.name)
                    .font(.largeTitle)
                    .bold()
                
                infoTextView
            }
            .frame(maxWidth: .infinity, alignment: .leading) // Ensure content aligns to the left
            .padding()
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
        .onOpenURL { url in
            handleLinkTap(url: url)
        }
    }

    private func handleLinkTap(url: URL) {
        let id = url.lastPathComponent
        if let selectedCharacter = allCharacters.first(where: { $0.id == id }) {
            router.navigateToCharacter(selectedCharacter)
        }
    }

    private var infoTextView: some View {
        let attributedString = buildAttributedString(from: character.info)
        return Text(attributedString)
            .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
    }

    private func buildAttributedString(from info: String) -> AttributedString {
        var attributedString = AttributedString()
        
        let linkRegex = try! NSRegularExpression(pattern: #"\[(.*?)\]\(#(.*?)\)"#, options: [])
        let italicRegex = try! NSRegularExpression(pattern: #"\_(.*?)\_"#, options: [])
        let combinedRegex = try! NSRegularExpression(pattern: #"\[(.*?)\]\(#(.*?)\)|\_(.*?)\_"#, options: [])
        
        let matches = combinedRegex.matches(in: info, options: [], range: NSRange(location: 0, length: info.utf16.count))
        
        var currentIndex = info.startIndex
        for match in matches {
            if let range = Range(match.range(at: 0), in: info) {
                let beforeText = String(info[currentIndex..<range.lowerBound])
                if !beforeText.isEmpty {
                    attributedString.append(AttributedString(beforeText))
                }
                
                if match.range(at: 1).location != NSNotFound,
                   let nameRange = Range(match.range(at: 1), in: info),
                   let idRange = Range(match.range(at: 2), in: info) {
                    
                    let name = String(info[nameRange])
                    let id = String(info[idRange])
                    
                    if let linkedCharacter = allCharacters.first(where: { $0.id == id }) {
                        var linkText = AttributedString(name)
                        linkText.foregroundColor = .blue
                        linkText.link = URL(string: "myappurl://character/\(linkedCharacter.id)")
                        attributedString.append(linkText)
                    } else {
                        attributedString.append(AttributedString(name))
                    }
                    
                } else if match.range(at: 3).location != NSNotFound,
                          let italicRange = Range(match.range(at: 3), in: info) {
                    
                    let italicText = String(info[italicRange])
                    var italicAttributedString = AttributedString(italicText)
                    italicAttributedString.font = Font.body.italic()
                    attributedString.append(italicAttributedString)
                }
                
                currentIndex = range.upperBound
            }
        }
        
        if currentIndex < info.endIndex {
            attributedString.append(AttributedString(String(info[currentIndex...])))
        }
        
        return attributedString
    }
}
