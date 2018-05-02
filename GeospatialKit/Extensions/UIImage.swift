import UIKit

extension UIImage {
    static func localImage(named name: String) -> UIImage {
        return UIImage(named: name, in: .source, compatibleWith: nil)!
    }
}
