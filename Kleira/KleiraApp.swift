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
    @State private var showLaunchScreen = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ZStack {
                    BackgroundGradientView()
                    ContentView()
                }
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.colorScheme)
                .tint(themeManager.accentColor)
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ThemeDidChange"))) { _ in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        themeManager.objectWillChange.send()
                    }
                }
                
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
            .environmentObject(themeManager)
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
