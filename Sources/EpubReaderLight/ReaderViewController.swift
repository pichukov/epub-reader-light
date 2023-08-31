import Foundation
import Combine
import SwiftUI

final public class ReaderViewController: ObservableObject {

    let webManager = WebManager()

    public init() {
        setUpDelegates()
    }

    private func setUpDelegates() {
        webManager.delegate = self
    }
}

extension ReaderViewController: WebManagerDelegate {

    func didReceiveMessage(message: Any) {
        print(message)
    }
}
