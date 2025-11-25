import WebKit

final class SessionManager {
    private var sessions: [String: WKWebView] = [:]
    private let runtimeJS = HeadlessBrowserRuntime.script

    subscript(sessionId: String) -> WKWebView? {
        get { sessions[sessionId] }
        set { sessions[sessionId] = newValue }
    }

    func require(sessionId: String) throws -> WKWebView {
      guard let webView = sessions[sessionId] else {
        throw SessionManagerError.noSuchSession(sessionId: sessionId)
      }
      return webView
    }

    func create() async -> String {
      let sessionId = UUID().uuidString
  
      await MainActor.run {
        let webViewConfig = WKWebViewConfiguration()
        let userContentController = WKUserContentController()

        userContentController.addUserScript(WKUserScript(
          source: runtimeJS,
          injectionTime: .atDocumentStart,
          forMainFrameOnly: false
        ))

        webViewConfig.userContentController = userContentController
        webViewConfig.websiteDataStore = .nonPersistent()

        let webView = WKWebView(frame: .zero, configuration: webViewConfig)
        sessions[sessionId] = webView
      }
      return sessionId
    }

    func close(sessionId: String) async throws -> Bool {
        guard let webView = sessions.removeValue(forKey: sessionId) else {
          throw SessionManagerError.noSuchSession(sessionId: sessionId)
        }

        try await MainActor.run {
          webView.stopLoading()
          webView.navigationDelegate = nil
          webView.removeFromSuperview()
        }

        return true
    }

    func reload(sessionId: String) async throws -> Bool {
        let webView = try self.require(sessionId: sessionId)

        try await MainActor.run { webView.reload() }
        try await webView.waitForLoad()

        return true
    }

    func navigate(sessionId: String, url: String) async throws -> Bool {
        let webView = try self.require(sessionId: sessionId)

        guard let _url = URL(string: url) else {
          throw SessionManagerError.invalidUrl(url: url)
         }

        try await MainActor.run {
          webView.load(URLRequest(url: _url))
        }

        try await webView.waitForLoad()
        return true
    }

    @MainActor
    func _executeScript<T>(sessionId: String, script: String) async throws -> T? {
        let webView = try self.require(sessionId: sessionId)

        let value = try await webView.evaluateJavaScript(script)
        return value as? T
    }
    
    func executeScript(sessionId: String, script: String) async throws -> String? {
        return try await _executeScript(sessionId: sessionId, script: script)
    }
    
    func executeScript(sessionId: String, script: String) async throws -> [String] {
        return try await _executeScript(sessionId: sessionId, script: script) ?? []
    }
    
    func dumpHtml(sessionId: String) async throws -> String? {
        let script = "document.documentElement.outerHTML"
    
        return try await executeScript(sessionId: sessionId, script: script)
    }

    func getTitle(sessionId: String) async throws -> String? {
      let script = "document.title"

      return try await executeScript(sessionId: sessionId, script: script)
    }

    func getCurrentUrl(sessionId: String) async throws -> String? {
      let script = "window.location.href"

      return try await executeScript(sessionId: sessionId, script: script)
    }
    
}
