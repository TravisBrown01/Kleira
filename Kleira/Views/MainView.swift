import SwiftUI

struct MainView: View {
    @StateObject private var cipherStore = CipherStore()
    @State private var showingCreateSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                if cipherStore.savedPhrases.isEmpty {
                    ContentUnavailableView(
                        "No Saved Ciphers",
                        systemImage: "lock.square",
                        description: Text("Create your first cipher to get started")
                    )
                } else {
                    ForEach(cipherStore.savedPhrases) { cipher in
                        NavigationLink(destination: ChartView(cipher: cipher)) {
                            CipherRowView(cipher: cipher)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            cipherStore.deletePhrase(cipherStore.savedPhrases[index])
                        }
                    }
                }
            }
            .navigationTitle("Kleira")
            .toolbar {
                Button {
                    showingCreateSheet = true
                } label: {
                    Label("Create New Cipher", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showingCreateSheet) {
                NavigationStack {
                    CreateCipherView()
                        .environmentObject(cipherStore)
                }
            }
        }
    }
}

#Preview {
    MainView()
} 