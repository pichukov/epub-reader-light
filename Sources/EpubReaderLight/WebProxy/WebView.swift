import SwiftUI
import WebKit
 
struct WebView: UIViewRepresentable {
 
    let manager: WebManager

    init(manager: WebManager) {
        self.manager = manager
    }
 
    func makeUIView(context: Context) -> WKWebView {
        return manager.webView
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = Bundle.currentModule.url(
            forResource: "index",
            withExtension: "html"
        ) else {
            #if DEBUG
            print("🔴 Error: Can't load web content from the given files")
            #endif
            return
        }
        let stringUrl = url.absoluteString + "?theme=\(manager.defaultTheme.rawValue)"
        guard let url = URL(string: stringUrl) else {
            #if DEBUG
            print("🔴 Error: Can't load web content from the given files")
            #endif
            return
        }
        #if DEBUG
        if #available(iOS 16.4, *) {
            manager.webView.isInspectable = true
        }
        #endif
        manager.webView.loadFileURL(
            url,
            allowingReadAccessTo: url.deletingLastPathComponent()
        )
    }
}
