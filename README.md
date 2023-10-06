<div align="center">
  <img width="400" src="https://raw.githubusercontent.com/pichukov/PublicAssets/master/EpubReader/EpubReaderLogo.png">
</div>

**EpubReaderLight** is a Swift package that that allow you to present the content of EPUB book. There are no any additional UI elements that will be showen except the book reader itself. It's implemented the way you will be able to provide a native experience for the user.

## Installation

It's a Swift Package, so you need to do the following:

- Open `File` in Xcode menu
- Open `Swift Packages`
- Choose `Add Package Dependency...` option
- In the `Enter package repository URL` field paste this URL: `https://github.com/pichukov/epub-reader-light`
- Choose any existing version or take it from `main` branch

## Usage

Add `import EpubReaderLight` to your swift file.

Create an instance of `ReaderViewController`:

```swift
let readerController = ReaderViewController(theme: .dark, eventsHandler: self)
```

- `theme`: initial `dark` or `light` mode for the reader
- `eventsHandler`: delegate that will handle events from reader

Class that will be injected as a delegate should conform `ReaderEventsHandler` protocol.

To load the book, you need to provide a local URL:

```swift
try? await readerController.loadBook(url: url)
```

You also can inject a default configuration:

```swift
try? await readerController.loadBook(
    url: url,
    bookSavedData: BookSavedData(
        theme: .light,
        fontSize: 24,
        font: "Avenir Next",
        page: 10
    )
)
```

- `theme`: initial `dark` or `light` mode for the reader
- `fontSize`: size of the font in book
- `font`: font style
- `page`: initial page that will be opened
