import SwiftUI
import PhotosUI

struct ChartView: View {
    let cipher: CipherPhrase
    @State private var inputWord = ""
    @State private var passwordGrid: PasswordGrid?
    @State private var generatedPassword = ""
    @State private var showingShareSheet = false
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingSaveSuccess = false
    @State private var showingSaveError = false
    @State private var photoSaver: PhotoSaver?
    @FocusState private var isInputFocused: Bool
    @State private var keyboardHeight: CGFloat = 0
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var shareText: String = ""
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.blue.opacity(0.1),
                Color.purple.opacity(0.05),
                Color(uiColor: .systemBackground)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private func prepareShareContent() -> String {
        """
        Cipher Chart: \(cipher.name)
        Generated by Kleira
        
        Input Phrase: \(cipher.phrase)
        Date Created: \(cipher.date.formatted())
        
        Note: This chart can be recreated using the same phrase in Kleira.
        """
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Title Section with gradient overlay
            VStack(alignment: .leading, spacing: 4) {
                Text("Kleira Cipher")
                    .font(.title.weight(.bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                themeManager.accentColor,
                                themeManager.accentColor.opacity(0.8)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text(cipher.phrase)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            Spacer(minLength: 0)
            
            // Cipher Grid
            if let grid = passwordGrid {
                ModernCipherGridView(grid: grid, onCharacterTap: { char in
                    withAnimation {
                        inputWord += String(char)
                    }
                })
                .transition(.opacity)
            }
            
            Spacer(minLength: 0)
            
            // Bottom Input Section
            VStack(spacing: 16) {
                // Input Field moved above results
                HStack(spacing: 12) {
                    Image(systemName: "key.fill")
                        .foregroundStyle(themeManager.accentColor)
                        .opacity(0.8)
                    
                    TextField("Enter word to convert", text: $inputWord)
                        .textFieldStyle(.plain)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .onChange(of: inputWord) { oldValue, newValue in
                            withAnimation(.spring(response: 0.3)) {
                                generatePassword()
                            }
                        }
                        .submitLabel(.done)
                        .focused($isInputFocused)
                    
                    if !inputWord.isEmpty {
                        Button(action: { 
                            withAnimation(.spring(response: 0.3)) {
                                inputWord = ""
                                generatedPassword = ""
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                                .opacity(0.8)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                }
                .padding(.horizontal)
                
                // Generated Password Display below input
                if !generatedPassword.isEmpty {
                    VStack(spacing: 12) {
                        Text(generatedPassword)
                            .font(.system(.title3, design: .monospaced))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.ultraThinMaterial)
                            }
                        
                        Button(action: {
                            UIPasteboard.general.string = generatedPassword
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)
                        }) {
                            Label("Copy", systemImage: "doc.on.doc.fill")
                                .font(.headline)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(themeManager.accentColor)
                    }
                    .padding(.horizontal)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding(.bottom, keyboardHeight > 0 ? keyboardHeight - 40 : 0)
            .animation(.easeOut(duration: 0.16), value: keyboardHeight)
        }
        .padding(.vertical)
        .background {
            backgroundGradient
                .ignoresSafeArea()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(isInputFocused)
        .tint(themeManager.accentColor)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    Task {
                        await saveToPhotos()
                    }
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.body.bold())
                        .foregroundStyle(themeManager.accentColor)
                }
            }
        }
        .alert("Saved to Photos", isPresented: $showingSaveSuccess) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("The cipher chart has been saved to your photo library.")
        }
        .alert("Could Not Save", isPresented: $showingSaveError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please make sure the app has permission to access your photos.")
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: [shareText])
        }
        .onAppear {
            withAnimation {
                passwordGrid = PasswordGrid(phrase: cipher.phrase)
            }
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillShowNotification,
                object: nil,
                queue: .main
            ) { notification in
                let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                keyboardHeight = keyboardFrame?.height ?? 0
            }
            
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillHideNotification,
                object: nil,
                queue: .main
            ) { _ in
                keyboardHeight = 0
            }
        }
        .gesture(
            DragGesture()
                .onChanged { _ in
                    if isInputFocused {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                      to: nil, from: nil, for: nil)
                    }
                }
        )
    }
    
    private func generatePassword() {
        if let grid = passwordGrid, !inputWord.isEmpty {
            generatedPassword = grid.generatePassword(from: inputWord)
        } else {
            generatedPassword = ""
        }
    }
    
    private func saveToPhotos() async {
        let renderer = ImageRenderer(content: 
            ChartShareView(cipher: cipher)
                .environmentObject(themeManager)
                .frame(maxWidth: UIScreen.main.bounds.width - 32)
        )
        renderer.scale = 3.0
        
        guard let image = renderer.uiImage else { return }
        
        do {
            let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
            guard status == .authorized else {
                await MainActor.run {
                    showingSaveError = true
                }
                return
            }
            
            try await PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
            await MainActor.run {
                showingSaveSuccess = true
            }
        } catch {
            await MainActor.run {
                showingSaveError = true
            }
        }
    }
}

// Separate view for sharing/saving
struct ChartShareView: View {
    let cipher: CipherPhrase
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 24) {
            // Title Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Kleira Cipher")
                    .font(.title.weight(.bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                themeManager.accentColor,
                                themeManager.accentColor.opacity(0.8)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text(cipher.phrase)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Create and use grid directly
            ModernCipherGridView(
                grid: PasswordGrid(phrase: cipher.phrase),
                onCharacterTap: { _ in }
            )
            
            Text("Generated with Kleira")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
}

// Photo manager to handle saving images
class PhotoManager {
    static func saveImage(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(
            image,
            nil,
            nil,
            nil
        )
    }
}

struct ModernCipherGridView: View {
    let grid: PasswordGrid
    let onCharacterTap: (Character) -> Void
    let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: PasswordGrid.gridWidth)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(0..<PasswordGrid.gridHeight, id: \.self) { row in
                ForEach(0..<PasswordGrid.gridWidth, id: \.self) { col in
                    if let char = grid.getCharacter(at: (row, col)) {
                        ModernCipherCell(char: char, code: grid.getCode(for: char) ?? "", onTap: {
                            onCharacterTap(char)
                        })
                    }
                }
            }
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal)
    }
}

struct ModernCipherCell: View {
    let char: Character
    let code: String
    let onTap: () -> Void
    @State private var isPressed = false
    @EnvironmentObject private var themeManager: ThemeManager
    
    private var cellGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(uiColor: .systemBackground),
                Color(uiColor: .systemBackground).opacity(0.95)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        Button(action: {
            onTap()
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }) {
            VStack(spacing: 2) {
                Text(String(char))
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(themeManager.accentColor)
                Text(code)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(.secondary)
            }
            .frame(minWidth: 44, minHeight: 44)
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(cellGradient)
                    .shadow(color: .black.opacity(0.03), radius: 3, y: 2)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.quaternary, lineWidth: 0.5)
            }
        }
        .buttonStyle(ModernButtonStyle())
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
    }
}

struct ModernButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

// ShareSheet wrapper for UIActivityViewController
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

class PhotoSaver: NSObject {
    var successHandler: () -> Void
    var errorHandler: () -> Void
    
    init(onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        self.successHandler = onSuccess
        self.errorHandler = onError
        super.init()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error == nil {
            successHandler()
        } else {
            errorHandler()
        }
    }
} 