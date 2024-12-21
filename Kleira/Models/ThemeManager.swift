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
        
        // Listen for system appearance changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(systemThemeChanged),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    func setTheme(_ theme: String) {
        selectedTheme = theme
        updateColorScheme()
        
        // Immediately update all windows
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .forEach { windowScene in
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = {
                        switch theme {
                        case "light": return .light
                        case "dark": return .dark
                        default: return .unspecified
                        }
                    }()
                }
            }
    }
    
    func setColorTheme(_ theme: String) {
        selectedColorTheme = theme
        updateAccentColor()
    }
    
    @objc private func systemThemeChanged() {
        updateColorScheme()
    }
    
    private func updateColorScheme() {
        withAnimation(.easeInOut(duration: 0.3)) {
            switch selectedTheme {
            case "light":
                colorScheme = .light
            case "dark":
                colorScheme = .dark
            default:
                colorScheme = nil
            }
        }
    }
    
    private func updateAccentColor() {
        withAnimation(.easeInOut(duration: 0.3)) {
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