import Foundation

private class BundleClass {}

internal extension Bundle {
    static var source: Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: BundleClass.self)
        #endif
    }
    
    static var sourceVersion: String { return source.infoDictionary?["CFBundleShortVersionString"] as? String ?? "" }
}
