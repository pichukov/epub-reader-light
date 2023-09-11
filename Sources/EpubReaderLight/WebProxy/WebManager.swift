import Foundation
import WebKit

typealias JSCallback = (Result<Any?, Error>) -> Void

struct JSFunction {
    var function: String
    var callback: JSCallback
}

protocol WebManagerDelegate {

    func didReceiveMessage(message: Any)
}

class WebManager: NSObject {

    let webView: WKWebView
    var defaultTheme: Theme = .light
    var delegate: WebManagerDelegate?

    private var pageLoaded = false
    private var pendingFunctions: [JSFunction] = []

    convenience init(theme: Theme) {
        self.init()
        self.defaultTheme = theme
    }

    override init() {
        let configuration = WKWebViewConfiguration()

        webView = WKWebView(frame: CGRect.zero, configuration: configuration)

        super.init()
        configuration.userContentController.add(self, name: Constants.messageName)
        webView.navigationDelegate = self
    }

    func callJS(function: String, callback: @escaping JSCallback) {
        if pageLoaded {
            callJS(function: makeFunction(withString: function, andCallback: callback))
        }
        else {
            add(function: makeFunction(withString: function, andCallback: callback))
        }
    }

    func load(_ request:URLRequest) {
        pageLoaded = false
        webView.load(request)
    }
}

//MARK: - Private functions

private extension WebManager {

    enum Constants {
        static let messageName = "nativeapp"
    }

    func add(function: JSFunction) {
        pendingFunctions.append(function)
    }

    func callJS(function: JSFunction) {
        webView.evaluateJavaScript(function.function) { response, error in
            if let error = error {
                function.callback(.failure(error))
            } else {
                function.callback(.success(response))
            }
        }
    }

    func callPendingFunctions() {
        for function in pendingFunctions {
            callJS(function: function)
        }
        pendingFunctions.removeAll()
    }

    func makeFunction(
        withString string: String,
        andCallback callback: @escaping JSCallback
    ) -> JSFunction {
        JSFunction(function: string, callback: callback)
    }
}

//MARK: - WKNavigationDelegate

extension WebManager: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        pageLoaded = true
        callPendingFunctions()
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        decisionHandler(.allow)
    }
}

//MARK: - WKScriptMessageHandler

extension WebManager: WKScriptMessageHandler {

    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        guard
            message.name == Constants.messageName,
            let body = message.body as? [String: AnyObject]
        else {
            print("⚠️ Unexpected message from Web View")
            return
        }
        delegate?.didReceiveMessage(message: body)
    }
}
