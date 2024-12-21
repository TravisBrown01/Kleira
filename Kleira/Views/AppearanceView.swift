import SwiftUI

struct AppearanceView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @AppStorage("selectedTheme") private var selectedTheme: String = "system"
    @AppStorage("selectedColorTheme") private var selectedColorTheme: String = "blue"
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            Section {
                Picker("Theme", selection: $selectedTheme) {
                    HStack {
                        Image(systemName: "iphone")
                        Text("System")
                    }
                    .tag("system")
                    
                    HStack {
                        Image(systemName: "sun.max.fill")
                        Text("Light")
                    }
                    .tag("light")
                    
                    HStack {
                        Image(systemName: "moon.fill")
                        Text("Dark")
                    }
                    .tag("dark")
                }
                .pickerStyle(.inline)
                .onChange(of: selectedTheme) { newValue in
                    themeManager.setTheme(newValue)
                }
            } header: {
                Text("APPEARANCE")
            } footer: {
                Text("Choose how Kleira appears on your device.")
            }
            
            Section {
                Picker("Color Theme", selection: $selectedColorTheme) {
                    HStack {
                        Circle()
                            .fill(.blue)
                            .frame(width: 20, height: 20)
                        Text("Blue")
                    }
                    .tag("blue")
                    
                    HStack {
                        Circle()
                            .fill(.purple)
                            .frame(width: 20, height: 20)
                        Text("Purple")
                    }
                    .tag("purple")
                    
                    HStack {
                        Circle()
                            .fill(.green)
                            .frame(width: 20, height: 20)
                        Text("Green")
                    }
                    .tag("green")
                    
                    HStack {
                        Circle()
                            .fill(.orange)
                            .frame(width: 20, height: 20)
                        Text("Orange")
                    }
                    .tag("orange")
                    
                    HStack {
                        Circle()
                            .fill(.red)
                            .frame(width: 20, height: 20)
                        Text("Red")
                    }
                    .tag("red")
                }
                .pickerStyle(.inline)
                .onChange(of: selectedColorTheme) { newValue in
                    themeManager.setColorTheme(newValue)
                }
            } header: {
                Text("COLOR THEME")
            } footer: {
                Text("Choose the accent color for the app.")
            }
        }
        .navigationTitle("Appearance")
        .navigationBarTitleDisplayMode(.inline)
        .tint(themeManager.accentColor)
    }
} 