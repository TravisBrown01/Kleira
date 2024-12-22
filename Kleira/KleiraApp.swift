//
//  KleiraApp.swift
//  Kleira
//
//  Created by Travis Brown on 12/19/24.
//

import SwiftUI
import UIKit

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
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ThemeDidChange"))) { _ in
                // Force view refresh
                withAnimation(.easeInOut(duration: 0.3)) {
                    // This will trigger a view update
                    themeManager.objectWillChange.send()
                }
            }
        }
    }
}

struct BackgroundGradientView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var themeManager: ThemeManager
    
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
    }
}
