import SwiftUI

struct AboutView: View {
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Kleira, short for Kleimera (Κλειμέρα), blends the Greek words "kleidi" (key) and "mera" (day), symbolizing daily security. Just as a key unlocks access, Kleira unlocks the power of simple, daily protection for your online world.")
                        .font(.body)
                    
                    Text("Our app is designed with simplicity in mind—quick, easy-to-use, and efficient. Generating strong, secure passwords has never been easier. With just a few taps, you can create unique, random passwords that keep your accounts safe. No complex steps, just fast, reliable protection every day. Kleira makes online security simple, so you can focus on what matters most—without worrying about your passwords.")
                        .font(.body)
                }
                .padding(.vertical, 8)
                .textSelection(.enabled)
            } header: {
                Text("About")
                    .textCase(.uppercase)
            }
            
            Section {
                Link(destination: URL(string: "https://www.apple.com/legal/privacy/")!) {
                    Label {
                        Text("Privacy Policy")
                            .foregroundStyle(.primary)
                    } icon: {
                        Image(systemName: "hand.raised.fill")
                            .foregroundStyle(.blue)
                    }
                }
                
                Link(destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!) {
                    Label {
                        Text("Terms of Use")
                            .foregroundStyle(.primary)
                    } icon: {
                        Image(systemName: "doc.text.fill")
                            .foregroundStyle(.purple)
                    }
                }
                
                Link(destination: URL(string: "https://www.apple.com")!) {
                    Label {
                        Text("Website")
                            .foregroundStyle(.primary)
                    } icon: {
                        Image(systemName: "globe")
                            .foregroundStyle(.green)
                    }
                }
            }
            
            Section {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(Bundle.main.appVersionLong)
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Build")
                    Spacer()
                    Text(Bundle.main.appBuild)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
} 