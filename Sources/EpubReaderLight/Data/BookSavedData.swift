public struct BookSavedData: Codable {

    public let locations: [String]?
    public let theme: Theme?
    public let fontSize: Int?
    public let font: String?
    public let page: Int?
    public let totalPages: Int?

    public init(
        locatios: [String]? = nil,
        theme: Theme? = nil,
        fontSize: Int? = nil,
        font: String? = nil,
        page: Int? = nil,
        totalPages: Int? = nil
    ) {
        self.locations = locatios
        self.theme = theme
        self.fontSize = fontSize
        self.font = font
        self.page = page
        self.totalPages = totalPages
    }
}
