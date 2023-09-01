public enum ReaderError: Error {
    case noDataForBookURL
    case bookLoadingFailed
    case scrollingFailed
    case changeThemeFailed
    case changeFontSizeFailed
    case wordsEncodingFailed
    case highlightWordsFailed
}
