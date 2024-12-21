import SwiftUI

struct DeveloperSettingsView: View {
    @AppStorage("alternativeIcon") private var alternativeIcon: String = "Default"
    @Environment(\.dismiss) private var dismiss
    @State private var showIconChangeError = false
    
    var body: some View {
        List {
            Section("App Information") {
                InfoRow(title: "Version",
                       value: Bundle.main.appVersionLong)
                InfoRow(title: "Build",
                       value: Bundle.main.appBuild)
                InfoRow(title: "Device",
                       value: UIDevice.current.modelName)
                InfoRow(title: "System",
                       value: UIDevice.current.systemVersion)
            }
            
            Section("App Icons") {
                Button {
                    changeAppIcon(to: nil)
                } label: {
                    HStack {
                        Image("AppIcon60x60")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .cornerRadius(12)
                        
                        Text("Default")
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        if UIApplication.shared.alternateIconName == nil {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.blue)
                        }
                    }
                }
                
                Button {
                    changeAppIcon(to: "Alternative")
                } label: {
                    HStack {
                        Image("Alternative")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .cornerRadius(12)
                        
                        Text("Alternative")
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        if UIApplication.shared.alternateIconName == "Alternative" {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
        }
        .navigationTitle("Developer Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .alert("Icon Change Failed", isPresented: $showIconChangeError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("There was an error changing the app icon. Please try again.")
        }
    }
    
    private func changeAppIcon(to iconName: String?) {
        guard UIApplication.shared.supportsAlternateIcons else {
            showIconChangeError = true
            return
        }
        
        Task {
            do {
                try await UIApplication.shared.setAlternateIconName(iconName)
                alternativeIcon = iconName == nil ? "Default" : iconName!
            } catch {
                print("Error changing app icon: \(error.localizedDescription)")
                showIconChangeError = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        DeveloperSettingsView()
    }
} 