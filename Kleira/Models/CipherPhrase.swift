import Foundation

struct CipherPhrase: Identifiable, Codable {
    let id: UUID
    let name: String
    let phrase: String
    let date: Date
    var isFavorite: Bool
    
    init(id: UUID = UUID(), name: String, phrase: String, date: Date = Date(), isFavorite: Bool = false) {
        self.id = id
        self.name = name
        self.phrase = phrase
        self.date = date
        self.isFavorite = isFavorite
    }
} 