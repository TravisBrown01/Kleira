import SwiftUI

struct AboutView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    
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
    
    private func getDistributionMethod() -> String {
        #if DEBUG
            return "Xcode"
        #else
            if Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" {
                return "TestFlight"
            } else if Bundle.main.appStoreReceiptURL?.path.contains("CoreSimulator") == true {
                return "Simulator"
            } else {
                return "App Store"
            }
        #endif
    }
    
    var body: some View {
        List {
            // App Info Section
            Section {
                HStack(spacing: 16) {
                    if let iconDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
                       let primaryIconDict = iconDictionary["CFBundlePrimaryIcon"] as? [String: Any],
                       let iconFiles = primaryIconDict["CFBundleIconFiles"] as? [String],
                       let lastIcon = iconFiles.last,
                       let icon = UIImage(named: lastIcon) {
                        Image(uiImage: icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(.quaternary, lineWidth: 0.5)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text("Kleira")
                                .font(.headline)
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
                        Text("Version \(appVersion)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            // About Section
            Section {
                Text("Kleira, short for Kleimera (Κλειμέρα), blends the Greek words 'kleidi' (key) and 'mera' (day), symbolizing daily security. Just as a key unlocks access, Kleira unlocks the power of simple, daily protection for your online world. Our app is designed with simplicity in mind—quick, easy-to-use, and efficient. Generating strong, secure passwords has never been easier. With just a few taps, you can create unique, random passwords that keep your accounts safe. No complex steps, just fast, reliable protection every day. Kleira makes online security simple, so you can focus on what matters most—without worrying about your passwords.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } header: {
                Label("ABOUT", systemImage: "info.circle.fill")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .textCase(.uppercase)
            }
            
            // Features Section
            Section {
                FeatureRow(icon: "lock.shield.fill", title: "Secure Generation", description: "Create unique cipher charts for password generation", iconColor: .blue)
                FeatureRow(icon: "key.fill", title: "Consistent Results", description: "Same phrase always generates the same chart", iconColor: .green)
                FeatureRow(icon: "lock.shield.fill", title: "Privacy Focused", description: "All data stored locally on your device", iconColor: .purple)
                FeatureRow(icon: "square.and.arrow.up", title: "Shareable", description: "Export and share your cipher charts", iconColor: .orange)
            } header: {
                Label("FEATURES", systemImage: "star.fill")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .textCase(.uppercase)
            }
            
            // Build Info Section
            Section {
                HStack {
                    Text("Version")
                    Spacer()
                    HStack(spacing: 8) {
                        Text(appVersion)
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
                    .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Build")
                    Spacer()
                    Text(buildNumber)
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Distribution")
                    Spacer()
                    Text(getDistributionMethod())
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Updated")
                    Spacer()
                    Text("December 2024")
                        .foregroundStyle(.secondary)
                }
            } header: {
                Label("BUILD INFORMATION", systemImage: "hammer.fill")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .textCase(.uppercase)
            }
            
            // Links Section
            Section {
                Link(destination: URL(string: "https://knovon.org/privacy-policy/")!) {
                    HStack {
                        Label("Privacy Policy", systemImage: "hand.raised.fill")
                        Spacer()
                        Image(systemName: "arrow.up.forward")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Link(destination: URL(string: "https://testflight.apple.com/join/nDENhDrp")!) {
                    HStack {
                        Label("Join Beta Testing", systemImage: "testtube.2")
                        Spacer()
                        Image(systemName: "arrow.up.forward")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Label("LINKS", systemImage: "link")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .textCase(.uppercase)
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
        .tint(themeManager.accentColor)
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(iconColor)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        AboutView()
            .environmentObject(ThemeManager())
    }
}
