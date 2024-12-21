import SwiftUI

struct DeveloperSettingsView: View {
    @AppStorage("alternativeIcon") private var alternativeIcon: String = "AppIcon"
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            Section(NSLocalizedString("App Information", bundle: .main, comment: "")) {
                InfoRow(title: NSLocalizedString("Version", bundle: .main, comment: ""),
                       value: Bundle.main.appVersionLong)
                InfoRow(title: NSLocalizedString("Build", bundle: .main, comment: ""),
                       value: Bundle.main.appBuild)
                InfoRow(title: NSLocalizedString("Device", bundle: .main, comment: ""),
                       value: UIDevice.current.modelName)
                InfoRow(title: NSLocalizedString("System", bundle: .main, comment: ""),
                       value: UIDevice.current.systemVersion)
            }
            
            Section(NSLocalizedString("App Icons", bundle: .main, comment: "")) {
                Button {
                    Task {
                        try? await UIApplication.shared.setAlternateIconName("AppIcon")
                        alternativeIcon = "AppIcon"
                    }
                } label: {
                    HStack {
                        Text("Default", bundle: .main)
                        Spacer()
                        if alternativeIcon == "AppIcon" {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                
                Button {
                    Task {
                        try? await UIApplication.shared.setAlternateIconName("Alternative")
                        alternativeIcon = "Alternative"
                    }
                } label: {
                    HStack {
                        Text("Alternative", bundle: .main)
                        Spacer()
                        if alternativeIcon == "Alternative" {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
        }
        .navigationTitle(Text("Developer Settings", bundle: .main))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DeveloperSettingsView()
    }
} 