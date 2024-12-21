import SwiftUI

struct ContentView: View {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var cipherStore = CipherStore()
    @State private var showSettings = false
    @State private var showNewCipherSheet = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                // App Icon and Title - Using Logo from assets
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(themeManager.accentColor.opacity(0.15))
                            .frame(width: 100, height: 100)
                            .blur(radius: 20)
                        
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .foregroundStyle(themeManager.accentColor)
                    }
                    .frame(minWidth: 44, minHeight: 44)
                    
                    VStack(spacing: 8) {
                        Text("Kleira")
                            .font(.largeTitle.weight(.bold))
                        Text("Secure Password Generation")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 32)
                
                // Create New Cipher Button - Following touch target and contrast guidelines
                Button {
                    showNewCipherSheet = true
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                            .font(.headline)
                        Text("Create New Cipher")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50) // Ensuring minimum 44pt height
                    .background(themeManager.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                // Your Ciphers List
                VStack(alignment: .leading) {
                    HStack {
                        Text("Your Ciphers")
                            .font(.title2.bold())
                        Spacer()
                        Text("\(cipherStore.savedPhrases.count) total")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                    
                    if cipherStore.savedPhrases.isEmpty {
                        ContentUnavailableView(
                            "No Saved Ciphers",
                            systemImage: "lock.square",
                            description: Text("Create your first cipher to get started")
                        )
                    } else {
                        List {
                            ForEach(cipherStore.savedPhrases) { cipher in
                                NavigationLink {
                                    ChartView(cipher: cipher)
                                } label: {
                                    CipherRowView(cipher: cipher)
                                }
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        cipherStore.deletePhrase(cipher)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .swipeActions(edge: .leading) {
                                    Button {
                                        cipherStore.toggleFavorite(cipher)
                                    } label: {
                                        Label("Favorite", systemImage: cipher.isFavorite ? "star.fill" : "star")
                                    }
                                    .tint(.yellow)
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gear")
                            .symbolRenderingMode(.hierarchical)
                            .frame(minWidth: 44, minHeight: 44) // Minimum touch target
                    }
                }
            }
            .sheet(isPresented: $showNewCipherSheet) {
                NavigationStack {
                    CreateChartView(cipherStore: cipherStore)
                }
            }
            .sheet(isPresented: $showSettings) {
                NavigationStack {
                    SettingsView()
                        .environmentObject(themeManager)
                }
            }
        }
        .environmentObject(themeManager)
        .tint(themeManager.accentColor)
    }
}

#Preview {
    ContentView()
} 