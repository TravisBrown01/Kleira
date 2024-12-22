import SwiftUI

struct LaunchScreen: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var themeManager: ThemeManager
    
    @State private var titleText = ""
    @State private var subtitleText = ""
    @State private var showCipher = false
    @State private var cipherOffset: CGFloat = 0
    @State private var binaryRows: [[String]] = Array(repeating: [], count: 10)
    @State private var showGrid = false
    @State private var gridOpacity: CGFloat = 0.05
    
    private let title = "KLEIRA"
    private let subtitle = "SECURE PASSWORD GENERATION"
    private let cipherChars = "!@#$%^&*()_+-=[]{}|;:,.<>?0123456789"
    private let binaryChars = "01"
    private let gridSize = 50
    
    var body: some View {
        ZStack {
            // Solid background
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            
            // Binary rain effect
            VStack(spacing: 4) {
                ForEach(0..<10, id: \.self) { row in
                    HStack(spacing: 4) {
                        ForEach(0..<20, id: \.self) { col in
                            Text(binaryRows[row].indices.contains(col) ? binaryRows[row][col] : "0")
                                .font(.system(size: 12, weight: .regular, design: .monospaced))
                                .foregroundStyle(themeManager.accentColor.opacity(0.3))
                        }
                    }
                }
            }
            .onAppear {
                startBinaryAnimation()
            }
            
            // Tech grid
            if showGrid {
                GeometryReader { geometry in
                    Path { path in
                        let horizontalSpacing = geometry.size.width / CGFloat(gridSize)
                        let verticalSpacing = geometry.size.height / CGFloat(gridSize)
                        
                        // Horizontal lines
                        for i in 0...gridSize {
                            let y = CGFloat(i) * verticalSpacing
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                        }
                        
                        // Vertical lines
                        for i in 0...gridSize {
                            let x = CGFloat(i) * horizontalSpacing
                            path.move(to: CGPoint(x: x, y: 0))
                            path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                        }
                    }
                    .stroke(themeManager.accentColor, lineWidth: 0.5)
                    .opacity(gridOpacity)
                }
                .onAppear {
                    withAnimation(.easeIn(duration: 1.0)) {
                        gridOpacity = 0.15
                    }
                }
            }
            
            // Main content
            VStack(spacing: 24) {
                // Title with typing effect
                Text(titleText)
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .foregroundStyle(themeManager.accentColor)
                    .onAppear {
                        animateTyping(for: title, to: $titleText, delay: 0.15)
                    }
                
                // Subtitle with typing effect
                Text(subtitleText)
                    .font(.system(size: 20, weight: .medium, design: .monospaced))
                    .foregroundStyle(Color.secondary)
                    .onAppear {
                        animateTyping(for: subtitle, to: $subtitleText, delay: 0.08, startDelay: 1.0)
                    }
                
                // Encryption visualization
                if showCipher {
                    VStack(spacing: 8) {
                        // Status text
                        Text("INITIALIZING ENCRYPTION PROTOCOLS")
                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                            .foregroundStyle(Color.secondary)
                        
                        // Cipher animation
                        HStack(spacing: 2) {
                            ForEach(0..<25) { index in
                                Text(String(Array(cipherChars.shuffled())[0]))
                                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                                    .foregroundStyle(themeManager.accentColor)
                                    .opacity(0.8)
                                    .offset(y: cipherOffset)
                                    .animation(
                                        .easeInOut(duration: 0.3)
                                        .repeatForever()
                                        .delay(Double(index) * 0.05),
                                        value: cipherOffset
                                    )
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            // Show grid after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    showGrid = true
                }
            }
            
            // Show cipher animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    showCipher = true
                    cipherOffset = 8
                }
            }
        }
    }
    
    private func startBinaryAnimation() {
        func updateBinaryRow() {
            for row in 0..<10 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(row) * 0.1) {
                    withAnimation {
                        binaryRows[row] = (0..<20).map { _ in
                            String(Array(binaryChars)[Int.random(in: 0..<binaryChars.count)])
                        }
                    }
                }
            }
        }
        
        // Initial update
        updateBinaryRow()
        
        // Continuous updates
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            updateBinaryRow()
        }
    }
    
    private func animateTyping(for text: String, to binding: Binding<String>, delay: Double, startDelay: Double = 0) {
        var charIndex = 0
        let timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: true) { timer in
            if charIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: charIndex)
                binding.wrappedValue += String(text[index])
                charIndex += 1
            } else {
                timer.invalidate()
            }
        }
        timer.fireDate = Date().addingTimeInterval(startDelay)
    }
}

#Preview {
    LaunchScreen()
        .environmentObject(ThemeManager())
} 