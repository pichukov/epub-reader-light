import Foundation

extension String {

    var alphanumeric: String {
        return self
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .joined()
            .lowercased()
    }
}
