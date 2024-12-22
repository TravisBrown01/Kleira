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
    @State private var showLaunchScreen = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environmentObject(themeManager)
                    .preferredColorScheme(themeManager.colorScheme)
                    .tint(themeManager.accentColor)
                
                if showLaunchScreen {
                    LaunchScreen()
                        .environmentObject(themeManager)
                        .transition(.opacity)
                        .zIndex(1)
                        .onAppear {
                            // Hide launch screen after animations
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    showLaunchScreen = false
                                }
                            }
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
    }
}
