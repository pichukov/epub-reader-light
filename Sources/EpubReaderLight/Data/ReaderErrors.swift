public enum ReaderError: Error {
    case noDataForBookURL
    case bookLoadingFailed
    case bookDataEncodingFailed
    case scrollingFailed
    case changeThemeFailed
    case changeFontSizeFailed
    case changeFontFailed
    case wordsEncodingFailed
    case highlightWordsFailed
}
