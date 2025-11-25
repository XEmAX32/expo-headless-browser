import WebKit

extension WKWebView {

    func waitForLoad() async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            
            func check() {
                if !self.isLoading {
                    cont.resume()
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        check()
                    }
                }
            }

            check()
        }
    }

}
