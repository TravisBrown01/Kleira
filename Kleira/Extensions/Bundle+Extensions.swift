import Foundation

extension Bundle {
    var appVersionLong: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    var appBuild: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
} 