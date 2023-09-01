import UIKit

public struct WordHighlight: Codable {
    public let value: String
    public let color: String

    public init(value: String, color: UIColor) {
        self.value = value
        self.color = color.hexString
    }
}

extension UIColor {
    var hexString: String {
        cgColor.components![0..<3]
            .map { String(format: "%02lX", Int($0 * 255)) }
            .reduce("#", +)
    }
}
