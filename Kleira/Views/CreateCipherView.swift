import SwiftUI

struct CreateCipherView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var cipherStore: CipherStore
    @State private var name = ""
    @State private var phrase = ""
    
    var body: some View {
        List {
            Section {
                TextField("Name", text: $name)
                TextField("Memorable Phrase", text: $phrase)
            } header: {
                Text("NEW CIPHER")
            } footer: {
                Text("Enter a memorable phrase that will be used to generate your cipher chart.")
            }
        }
        .navigationTitle("Create Cipher")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Create") {
                    cipherStore.addPhrase(name: name, phrase: phrase)
                    dismiss()
                }
                .disabled(name.isEmpty || phrase.isEmpty)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CreateCipherView()
            .environmentObject(CipherStore())
    }
} 