import SwiftUI

struct CipherRowView: View {
    let cipher: CipherPhrase
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(cipher.name)
                .font(.headline)
            
            Text(cipher.phrase)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    CipherRowView(cipher: CipherPhrase(name: "Test Name", phrase: "Example Phrase"))
} 

