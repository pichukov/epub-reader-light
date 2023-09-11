public struct BookData: Codable {
    public let base64: String
    public let defaultHighlightedWords: [WordHighlight]?
    public let savedData: BookSavedData?
}
