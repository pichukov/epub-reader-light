public struct BookEvent<T: Decodable>: Decodable {
    public let value: T
}

public enum BookEventType: String, Codable {
    case saveWord
}
