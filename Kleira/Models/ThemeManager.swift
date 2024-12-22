import SwiftUI
import UIKit

@MainActor
class ThemeManager: ObservableObject {
    @AppStorage("selectedTheme") private(set) var selectedTheme: String = "system" {
        didSet {
            updateColorScheme()
        }
    }
    @AppStorage("selectedColorTheme") private var selectedColorTheme: String = "blue"
    
    @Published var colorScheme: ColorScheme?
    @Published var accentColor: Color = .blue
    
    init() {
        updateColorScheme()
        updateAccentColor()
        applyInitialTheme()
    }
    
    private func applyInitialTheme() {
        // Get all scenes and apply theme to each window
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .forEach { scene in
                scene.windows.forEach { window in
                    applyTheme(to: window)
                }
            }
    }
    
    func setTheme(_ theme: String) {
        selectedTheme = theme.lowercased()
        
        // Apply to all windows in all scenes
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .forEach { scene in
                scene.windows.forEach { window in
                    applyTheme(to: window)
                }
            }
        
        // Post notification for views to update
        NotificationCenter.default.post(name: NSNotification.Name("ThemeDidChange"), object: nil)
    }
    
    private func applyTheme(to window: UIWindow) {
        let style: UIUserInterfaceStyle = {
            switch selectedTheme {
            case "light": return .light
            case "dark": return .dark
            default: return .unspecified
            }
        }()
        
        // Apply the style changes within the main thread
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                window.overrideUserInterfaceStyle = style
                window.rootViewController?.setNeedsStatusBarAppearanceUpdate()
                window.subviews.forEach { $0.setNeedsDisplay() }
            }
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