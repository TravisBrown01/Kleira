//
//  KleiraApp.swift
//  Kleira
//
//  Created by Travis Brown on 12/19/24.
//

import SwiftUI

@main
struct KleiraApp: App {
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                BackgroundGradientView()
                ContentView()
            }
            .environmentObject(themeManager)
            .preferredColorScheme(themeManager.colorScheme)
            .tint(themeManager.accentColor)
            .onChange(of: themeManager.colorScheme) { oldScheme, newScheme in
                // Force immediate UI update for theme changes
                UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .forEach { windowScene in
                        windowScene.windows.forEach { window in
                            window.overrideUserInterfaceStyle = {
                                switch themeManager.selectedTheme {
                                case "light": return .light
                                case "dark": return .dark
                                default: return .unspecified
                                }
                            }()
                        }
                    }
            }
        }
    }
}

struct BackgroundGradientView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        LinearGradient(
            colors: colorScheme == .dark ? [
                Color(uiColor: .systemBackground),
                Color(uiColor: .systemBackground).opacity(0.8),
                Color.blue.opacity(0.05)
            ] : [
                Color.blue.opacity(0.1),
                Color(uiColor: .systemBackground).opacity(0.95),
                Color(uiColor: .systemBackground)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 0.3), value: colorScheme)
    }
}
