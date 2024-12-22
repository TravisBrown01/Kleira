import SwiftUI

struct AppearanceView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let themes = [
        ("System", "iphone"),
        ("Light", "sun.max.fill"),
        ("Dark", "moon.fill")
    ]
    
    private let colors: [(name: String, color: SwiftUI.Color)] = [
        ("Blue", SwiftUI.Color.blue),
        ("Purple", SwiftUI.Color.purple),
        ("Green", SwiftUI.Color.green),
        ("Orange", SwiftUI.Color.orange),
        ("Pink", SwiftUI.Color.pink),
        ("Red", SwiftUI.Color.red),
        ("Yellow", SwiftUI.Color.yellow),
        ("Mint", SwiftUI.Color.mint),
        ("Teal", SwiftUI.Color.teal),
        ("Indigo", SwiftUI.Color.indigo)
    ]
    
    var body: some View {
        List {
            Section("Theme") {
                ForEach(themes, id: \.0) { theme in
                    Button {
                        withAnimation {
                            themeManager.setTheme(theme.0)
                        }
                    } label: {
                        HStack {
                            Label(theme.0, systemImage: theme.1)
                            Spacer()
                            if themeManager.selectedTheme == theme.0.lowercased() {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(themeManager.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Section("Accent Color") {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 44), spacing: 8)
                ], spacing: 8) {
                    ForEach(colors, id: \.name) { colorInfo in
                        Circle()
                            .fill(colorInfo.color)
                            .frame(width: 44, height: 44)
                            .overlay {
                                if themeManager.accentColor == colorInfo.color {
                                    Image(systemName: "checkmark")
                                        .font(.headline.bold())
                                        .foregroundStyle(.white)
                                }
                            }
                            .contentShape(Circle())
                            .onTapGesture {
                                withAnimation {
                                    themeManager.setColorTheme(colorInfo.name.lowercased())
                                }
                            }
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Appearance")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AppearanceView()
            .environmentObject(ThemeManager())
    }
} 