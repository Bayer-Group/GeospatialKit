import Foundation

private class BundleClass {}

internal extension Bundle {
    static var source: Bundle { Bundle(for: BundleClass.self) }
    
    static var sourceVersion: String { source.infoDictionary?["CFBundleShortVersionString"] as? String ?? "SPM" }
}
