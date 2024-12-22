import SwiftUI

@MainActor
class ThemeManager: ObservableObject {
    @AppStorage("selectedTheme") private(set) var selectedTheme: String = "system"
    @AppStorage("selectedColorTheme") private var selectedColorTheme: String = "blue"
    
    @Published var colorScheme: ColorScheme?
    @Published var accentColor: Color = .blue
    
    init() {
        updateColorScheme()
        updateAccentColor()
        setInitialTheme()
    }
    
    func setTheme(_ theme: String) {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedTheme = theme.lowercased()
            updateColorScheme()
            
            // Immediately update window style
            setWindowStyle(for: selectedTheme)
        }
    }
    
    private func setInitialTheme() {
        setWindowStyle(for: selectedTheme)
    }
    
    private func setWindowStyle(for theme: String) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return }
        
        let style: UIUserInterfaceStyle = {
            switch theme {
            case "light": return .light
            case "dark": return .dark
            default: return .unspecified
            }
        }()
        
        window.overrideUserInterfaceStyle = style
    }
    
    private func updateColorScheme() {
        colorScheme = {
            switch selectedTheme {
            case "light": return .light
            case "dark": return .dark
            default: return nil
            }
        }()
    }
    
    func setColorTheme(_ theme: String) {
        selectedColorTheme = theme
        updateAccentColor()
    }
    
    private func updateAccentColor() {
        withAnimation {
            switch selectedColorTheme {
            case "purple": accentColor = .purple
            case "green": accentColor = .green
            case "orange": accentColor = .orange
            case "pink": accentColor = .pink
            case "red": accentColor = .red
            case "yellow": accentColor = .yellow
            case "mint": accentColor = .mint
            case "teal": accentColor = .teal
            case "indigo": accentColor = .indigo
            default: accentColor = .blue
            }
        }
    }
} 