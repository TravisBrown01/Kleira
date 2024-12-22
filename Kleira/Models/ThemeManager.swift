import SwiftUI
import UIKit

@MainActor
class ThemeManager: ObservableObject {
    @AppStorage("selectedTheme") private(set) var selectedTheme: String = "system" {
        didSet {
            updateColorScheme()
            applyThemeToAllWindows()
        }
    }
    @AppStorage("selectedColorTheme") private var selectedColorTheme: String = "blue"
    
    @Published var colorScheme: ColorScheme?
    @Published var accentColor: Color = .blue
    
    init() {
        updateColorScheme()
        updateAccentColor()
        applyThemeToAllWindows()
    }
    
    func setTheme(_ theme: String) {
        selectedTheme = theme.lowercased()
    }
    
    private func applyThemeToAllWindows() {
        let style: UIUserInterfaceStyle = {
            switch selectedTheme {
            case "light": return .light
            case "dark": return .dark
            default: return .unspecified
            }
        }()
        
        // Apply to all scenes and windows
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                window.overrideUserInterfaceStyle = style
                window.rootViewController?.setNeedsStatusBarAppearanceUpdate()
                
                // Force window update
                window.setNeedsLayout()
                window.layoutIfNeeded()
                
                // Force view update
                if let rootView = window.rootViewController?.view {
                    rootView.setNeedsLayout()
                    rootView.layoutIfNeeded()
                    rootView.setNeedsDisplay()
                }
            }
        }
        
        // Force SwiftUI update
        DispatchQueue.main.async { [weak self] in
            self?.objectWillChange.send()
        }
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