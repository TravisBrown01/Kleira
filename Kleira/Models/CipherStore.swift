import Foundation

@MainActor
class CipherStore: ObservableObject {
    @Published private(set) var savedPhrases: [CipherPhrase] = []
    private let saveKey = "SavedCiphers"
    
    init() {
        loadCiphers()
        sortCiphers()
    }
    
    func addPhrase(name: String, phrase: String) {
        let cipher = CipherPhrase(name: name, phrase: phrase)
        savedPhrases.insert(cipher, at: 0)
        saveCiphers()
        sortCiphers()
    }
    
    func toggleFavorite(_ cipher: CipherPhrase) {
        if let index = savedPhrases.firstIndex(where: { $0.id == cipher.id }) {
            var updatedCipher = cipher
            updatedCipher.isFavorite.toggle()
            savedPhrases[index] = updatedCipher
            saveCiphers()
            sortCiphers()
        }
    }
    
    func deletePhrase(_ cipher: CipherPhrase) {
        savedPhrases.removeAll { $0.id == cipher.id }
        saveCiphers()
    }
    
    private func sortCiphers() {
        savedPhrases.sort { first, second in
            if first.isFavorite == second.isFavorite {
                return first.date > second.date // Newer first
            }
            return first.isFavorite && !second.isFavorite // Favorites first
        }
    }
    
    private func saveCiphers() {
        do {
            let data = try JSONEncoder().encode(savedPhrases)
            UserDefaults.standard.set(data, forKey: saveKey)
        } catch {
            print("Failed to save ciphers: \(error.localizedDescription)")
        }
    }
    
    private func loadCiphers() {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else { return }
        
        do {
            savedPhrases = try JSONDecoder().decode([CipherPhrase].self, from: data)
        } catch {
            print("Failed to load ciphers: \(error.localizedDescription)")
        }
    }
} 