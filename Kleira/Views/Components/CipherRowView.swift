import SwiftUI

struct CipherRowView: View {
    let cipher: CipherPhrase
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            // Cipher Icon - Updated to use theme accent color
            ZStack {
                Circle()
                    .fill(themeManager.accentColor.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: "grid.circle.fill")
                    .font(.title2)
                    .foregroundStyle(themeManager.accentColor)
            }
            
            // Cipher Details
            VStack(alignment: .leading, spacing: 4) {
                Text(cipher.name)
                    .font(.headline)
                
                Text(cipher.phrase)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .padding(.leading, 8)
            
            Spacer()
            
            // Favorite star if favorited
            if cipher.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                    .font(.subheadline)
                    .padding(.trailing, 4)
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(cipher.name): \(cipher.phrase)")
    }
}

#Preview {
    CipherRowView(cipher: CipherPhrase(name: "Sample Cipher", phrase: "Test phrase", date: Date()))
        .padding()
        .environmentObject(ThemeManager())
} 