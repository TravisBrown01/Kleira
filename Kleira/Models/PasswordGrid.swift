struct PasswordGrid {
    static let gridWidth = 5
    static let gridHeight = 7
    
    private var grid: [[Character]]
    private var rng: MersenneTwister
    private var characterToCode: [Character: String] = [:]
    
    init(phrase: String) {
        // Initialize empty grid with ordered characters
        grid = Self.createOrderedGrid()
        
        // Initialize RNG with seed from phrase
        let seed = HashGenerator.generateSeed(from: phrase)
        rng = MersenneTwister(seed: seed)
        
        generateCharacterCodes()
    }
    
    private static func createOrderedGrid() -> [[Character]] {
        // Create ordered list of characters A-Z followed by 1-9
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789"
        var grid = Array(repeating: Array(repeating: Character(" "), count: gridWidth), count: gridHeight)
        
        // Fill grid in order
        var index = 0
        for row in 0..<gridHeight {
            for col in 0..<gridWidth {
                if index < characters.count {
                    grid[row][col] = characters[characters.index(characters.startIndex, offsetBy: index)]
                    index += 1
                }
            }
        }
        
        return grid
    }
    
    private mutating func generateCharacterCodes() {
        let codeCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-+=<>?"
        
        for row in 0..<Self.gridHeight {
            for col in 0..<Self.gridWidth {
                let char = grid[row][col]
                
                // Generate a random 4-character code
                var code = ""
                for _ in 0..<4 {
                    let randomIndex = Int(rng.extract()) % codeCharacters.count
                    let codeChar = codeCharacters[codeCharacters.index(codeCharacters.startIndex, offsetBy: randomIndex)]
                    code.append(codeChar)
                }
                
                characterToCode[char] = code
            }
        }
    }
    
    func getCharacter(at position: (row: Int, col: Int)) -> Character? {
        guard position.row >= 0 && position.row < Self.gridHeight,
              position.col >= 0 && position.col < Self.gridWidth else {
            return nil
        }
        return grid[position.row][position.col]
    }
    
    func getCode(for char: Character) -> String? {
        return characterToCode[char.uppercased().first ?? char]
    }
    
    func generatePassword(from input: String) -> String {
        var result = ""
        
        for char in input.uppercased() {
            if let code = getCode(for: char) {
                result += code
            } else {
                // If character not found in grid, use it as-is
                result += String(char)
            }
        }
        
        return result
    }
} 