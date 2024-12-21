import Foundation
import CryptoKit

struct HashGenerator {
    static func generateSeed(from phrase: String) -> UInt32 {
        // Get MD5 hash
        let digest = Insecure.MD5.hash(data: phrase.data(using: .utf8) ?? Data())
        
        // Convert digest to array of bytes and take first 4
        let bytes = Array(digest)
        let seedBytes = Data(bytes.prefix(4))
        
        // Convert to UInt32
        return seedBytes.withUnsafeBytes { bytes in
            bytes.load(as: UInt32.self)
        }
    }
} 