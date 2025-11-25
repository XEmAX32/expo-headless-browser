extension SessionManager {
    func wait(
      milliseconds: TimeInterval = 10
    ) async throws -> Bool {
      try await Task.sleep(nanoseconds: UInt64(milliseconds * 1_000_000))
    }

    func waitForElement(
            sessionId: String,
            selector: String,
            timeout: TimeInterval = 10
        ) async throws -> String? {
            let pollInterval: TimeInterval = 0.2

            let escaped = selector
                .replacingOccurrences(of: "'", with: "\\'")
                .replacingOccurrences(of: "\n", with: " ")

            let script = """
                (function() {
                  try {
                    const el = document.querySelector('\(escaped)');
                    return el ? window.__expoWD.toId(el) : null;
                  } catch (e) {
                    return null;
                  }
                })();
            """

            let start = Date()
            
            while Date().timeIntervalSince(start) < timeout {
                if let result = try await executeScript(sessionId: sessionId, script: script) as String? {
                    return result
                }
                try await Task.sleep(nanoseconds: UInt64(pollInterval * 1_000_000_000))
            }
            
            return nil
        }
}
