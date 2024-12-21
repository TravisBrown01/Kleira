import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showDeveloperSettings = false
    
    private var buildType: (String, Color)? {
        #if DEBUG
            return ("ALPHA", .red)
        #else
            if Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" {
                return ("BETA", .blue)
            }
            return nil
        #endif
    }
    
    var body: some View {
        List {
            // App Info Section
            Section {
                HStack(spacing: 16) {
                    if let icon = UIImage(named: "AppIcon60x60") {
                        Image(uiImage: icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .cornerRadius(16)
                            .onTapGesture(count: 7) {
                                showDeveloperSettings = true
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text("Kleira")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            if let (tag, color) = buildType {
                                Text(tag)
                                    .font(.caption2.bold())
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .background(color.opacity(0.2))
                                    .foregroundStyle(color)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                            }
                        }
                        
                        Text("Secure Password Generation")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .listRowInsets(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0))
                .listRowBackground(Color.clear)
                .padding(.horizontal)
            }
            
            // Appearance Section
            Section {
                NavigationLink {
                    AppearanceView()
                } label: {
                    Label {
                        Text("Appearance")
                    } icon: {
                        Image(systemName: "paintpalette.fill")
                            .foregroundStyle(.purple)
                    }
                }
            }
            
            // Main Options Section
            Section {
                NavigationLink {
                    AboutView()
                } label: {
                    Label {
                        Text("About")
                    } icon: {
                        Image(systemName: "info.circle.fill")
                            .foregroundStyle(.blue)
                    }
                }
                
                NavigationLink {
                    CreditsView()
                } label: {
                    Label {
                        Text("Credits")
                    } icon: {
                        Image(systemName: "person.2.fill")
                            .foregroundStyle(.green)
                    }
                }
                
                // External Links with different colors
                Link(destination: URL(string: "itms-apps://apple.com/app/id6739615639")!) {
                    Label {
                        Text("Rate App")
                            .foregroundStyle(.primary)
                    } icon: {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                    }
                }
                
                Link(destination: URL(string: "mailto:Feedback@kailuamedia.com")!) {
                    Label {
                        Text("Send Feedback")
                            .foregroundStyle(.primary)
                    } icon: {
                        Image(systemName: "envelope.fill")
                            .foregroundStyle(.orange)
                    }
                }
                
                Link(destination: URL(string: "https://testflight.apple.com/join/nDENhDrp")!) {
                    Label {
                        Text("Join Beta Testing")
                            .foregroundStyle(.primary)
                    } icon: {
                        Image(systemName: "hammer.circle.fill")
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $showDeveloperSettings) {
            NavigationStack {
                DeveloperSettingsView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(ThemeManager())
    }
} 
