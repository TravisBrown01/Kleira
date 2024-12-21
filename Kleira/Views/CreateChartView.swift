import SwiftUI

struct CreateChartView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var cipherStore: CipherStore
    @State private var name = ""
    @State private var phrase = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Enter a title", text: $name)
                } header: {
                    Text("Cipher Name")
                }
                
                Section {
                    TextField("Enter a memorable phrase", text: $phrase)
                } header: {
                    Text("Cipher Phrase")
                } footer: {
                    Text("This phrase will be used to generate your unique cipher chart. Make it memorable but hard to guess.")
                }
            }
            .navigationTitle("Create New Cipher")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                           phrase.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            showingError = true
                        } else {
                            cipherStore.addPhrase(name: name, phrase: phrase)
                            dismiss()
                        }
                    }
                }
            }
            .alert("Invalid Input", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter both a name and a phrase")
            }
        }
    }
} 