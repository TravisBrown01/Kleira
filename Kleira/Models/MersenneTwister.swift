struct MersenneTwister {
    private var mt: [UInt32]
    private var index: Int
    
    init(seed: UInt32) {
        mt = Array(repeating: 0, count: 624)
        index = 0
        
        mt[0] = seed
        for i in 1..<624 {
            mt[i] = 0x6c078965 &* (mt[i-1] ^ (mt[i-1] >> 30)) &+ UInt32(i)
        }
    }
    
    mutating func extract() -> UInt32 {
        if index == 0 {
            twist()
        }
        
        var y = mt[index]
        y = y ^ (y >> 11)
        y = y ^ ((y << 7) & 0x9d2c5680)
        y = y ^ ((y << 15) & 0xefc60000)
        y = y ^ (y >> 18)
        
        index = (index + 1) % 624
        return y
    }
    
    private mutating func twist() {
        for i in 0..<624 {
            let y = (mt[i] & 0x80000000) + (mt[(i+1) % 624] & 0x7fffffff)
            mt[i] = mt[(i + 397) % 624] ^ (y >> 1)
            if y % 2 != 0 {
                mt[i] = mt[i] ^ 0x9908b0df
            }
        }
    }
} 