public protocol ReaderEventsHandler: AnyObject {
    func onSelect(word: String)
    func onBookLoaded()
    func onUpdated(savedData: BookSavedData)
}
