import SwiftUI

public struct ReaderView: View {

    @ObservedObject private var controller: ReaderViewController

    public init(controller: ReaderViewController) {
        _controller = ObservedObject(wrappedValue: controller)
    }

    public var body: some View {
        WebView(manager: controller.webManager)
            .ignoresSafeArea()
    }
}

struct ReaderView_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView(controller: ReaderViewController())
    }
}
