import Foundation
import Combine
import SwiftUI

final public class ReaderViewController: ObservableObject {

    let webManager: WebManager
    private weak var eventsHandler: ReaderEventsHandler?

    public init(theme: Theme, eventsHandler: ReaderEventsHandler? = nil) {
        self.webManager = WebManager(theme: theme)
        self.eventsHandler = eventsHandler
        setUpDelegates()
    }

    @MainActor
    public func loadBook(
        url: URL,
        bookSavedData: BookSavedData? = nil,
        highlights: [WordHighlight]? = nil
    ) async throws {
        guard let data = try? Data(contentsOf: url) else {
            print("⚠️ Error: No data for file URL \(url.absoluteString)")
            throw ReaderError.noDataForBookURL
        }
        let bookData = BookData(
            base64: data.base64EncodedString(),
            defaultHighlightedWords: highlights,
            savedData: bookSavedData
        )
        guard
            let data = try? JSONEncoder().encode(bookData),
            let stringValue = String(data: data, encoding: .utf8)
        else {
            throw ReaderError.bookDataEncodingFailed
        }

        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            webManager.callJS(function: "loadBook('\(stringValue)')") { result in
                switch result {
                case .success:
                    continuation.resume(returning: Void())
                case .failure(let error):
                    print("⚠️ loadBook failed with error: \(error)")
                    continuation.resume(throwing: ReaderError.bookLoadingFailed)
                }
            }
        }
    }

    @MainActor
    public func scroll(toPage page: Int) async throws {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            webManager.callJS(function: "goToPage('\(page)')") { result in
                switch result {
                case .success:
                    continuation.resume(returning: Void())
                case .failure(let error):
                    print("⚠️ scrollToPage failed with error: \(error)")
                    continuation.resume(throwing: ReaderError.scrollingFailed)
                }
            }
        }
    }

    @MainActor
    public func change(theme: Theme) async throws {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            webManager.callJS(function: "changeTheme('\(theme.rawValue)')") { result in
                switch result {
                case .success:
                    continuation.resume(returning: Void())
                case .failure(let error):
                    print("⚠️ changeTheme failed with error: \(error)")
                    continuation.resume(throwing: ReaderError.changeThemeFailed)
                }
            }
        }
    }

    @MainActor
    public func change(fontSize: Int) async throws {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            webManager.callJS(function: "changeFontSize(\(fontSize))") { result in
                switch result {
                case .success:
                    continuation.resume(returning: Void())
                case .failure(let error):
                    print("⚠️ changeFontSize failed with error: \(error)")
                    continuation.resume(throwing: ReaderError.changeFontSizeFailed)
                }
            }
        }
    }

    @MainActor
    public func change(font: String) async throws {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            webManager.callJS(function: "changeFont('\(font)')") { result in
                switch result {
                case .success:
                    continuation.resume(returning: Void())
                case .failure(let error):
                    print("⚠️ changeFont failed with error: \(error)")
                    continuation.resume(throwing: ReaderError.changeFontFailed)
                }
            }
        }
    }

    @MainActor
    public func highlight(words: [WordHighlight]) async throws {
        guard
            let data = try? JSONEncoder().encode(words),
            let stringValue = String(data: data, encoding: .utf8)
        else {
            throw ReaderError.wordsEncodingFailed
        }
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            webManager.callJS(function: "highlightWords('\(stringValue)')") { result in
                switch result {
                case .success:
                    continuation.resume(returning: Void())
                case .failure(let error):
                    print("⚠️ highlighWords failed with error: \(error)")
                    continuation.resume(throwing: ReaderError.highlightWordsFailed)
                }
            }
        }
    }

    @MainActor
    public func unhighlight(words: [String]) async throws {
        guard
            let data = try? JSONEncoder().encode(words),
            let stringValue = String(data: data, encoding: .utf8)
        else {
            throw ReaderError.wordsEncodingFailed
        }
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            webManager.callJS(function: "unhighlightWords('\(stringValue)')") { result in
                switch result {
                case .success:
                    continuation.resume(returning: Void())
                case .failure(let error):
                    print("⚠️ highlighWords failed with error: \(error)")
                    continuation.resume(throwing: ReaderError.highlightWordsFailed)
                }
            }
        }
    }

    private func setUpDelegates() {
        webManager.delegate = self
    }
}

extension ReaderViewController: WebManagerDelegate {

    func didReceiveMessage(message: Any) {
        guard
            let dict = message as? [String: AnyObject],
            let event = dict["event"] as? String,
            let eventType = BookEventType(rawValue: event),
            let data = try? JSONSerialization.data(withJSONObject: dict, options: [])
        else {
            print("⚠️ Wrong structure of Event object")
            return
        }
        switch eventType {
        case .saveWord:
            guard let word: String = parseEvent(data: data) else {
                print("⚠️ Error in Word Event parsing")
                return
            }
            eventsHandler?.onSelect(word: word.alphanumeric)
        case .onBookLoaded:
            eventsHandler?.onBookLoaded()
        case .setSavedData:
            guard let savedData: BookSavedData = parseEvent(data: data) else {
                print("⚠️ Error in set saved data Event parsing")
                return
            }
            eventsHandler?.onUpdated(savedData: savedData)
        }
    }

    private func parseEvent<T: Decodable>(data: Data) -> T? {
        print(data.jsonString)
        return try? JSONDecoder().decode(BookEvent<T>.self, from: data).value
    }
}
