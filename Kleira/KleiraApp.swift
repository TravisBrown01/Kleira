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
