import SwiftUI

struct CreditsView: View {
    var body: some View {
        List {
            // Thank You Section (outside of cells)
            HStack {
                VStack(spacing: 8) {
                    Text("Thank You!")
                        .font(.title.bold())
                        .padding(.top, 20)
                    
                    Text("For being part of the Kleira journey")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 20)
                }
            }
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
            
            // Core Development Team Section
            Section {
                // Travis Brown
                HStack(spacing: 16) {
                    if let image = UIImage(named: "TravisPhoto") {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Travis Brown")
                            .font(.headline)
                        Text("Lead Developer")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("App Engineer")
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                    }
                }
                .padding(.vertical, 8)
                
                // Tyson Brown
                HStack(spacing: 16) {
                    if let image = UIImage(named: "TysonPhoto") {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text("TB")
                                    .font(.headline)
                                    .foregroundStyle(.blue)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Tyson Brown")
                            .font(.headline)
                        Text("Graphic Designer")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("UI/UX Design")
                            .font(.subheadline)
                            .foregroundStyle(.purple)
                    }
                }
                .padding(.vertical, 8)
            } header: {
                Text("CORE DEVELOPMENT TEAM")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
            }
            
            // Special Thanks Section
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Beta Testers")
                        .font(.headline)
                    
                    Text("Thank you to all our amazing beta testers who helped shape Kleira with their valuable feedback and suggestions.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            } header: {
                Text("SPECIAL THANKS")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
            }
            
            // Technologies Section
            Section {
                TechnologyRow(name: "SwiftUI", description: "User Interface Framework")
                TechnologyRow(name: "CryptoKit", description: "Cryptographic Operations")
            } header: {
                Text("TECHNOLOGIES")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Credits")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TechnologyRow: View {
    let name: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .font(.headline)
            Text(description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationStack {
        CreditsView()
    }
}
