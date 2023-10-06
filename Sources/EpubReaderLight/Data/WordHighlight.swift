import UIKit

public struct WordHighlight: Codable {
    public let value: String
    public let color: String

    public init(value: String, color: UIColor) {
        self.value = value
        self.color = color.hexString
    }
}
