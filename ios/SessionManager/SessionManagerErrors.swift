enum SessionManagerError: LocalizedError {
  case noSuchSession(sessionId: String)
  case invalidUrl(url: String)

  var errorDescription: String? {
    switch self {
    case .noSuchSession(let sessionId):
      return "No headless browser session found for id \(sessionId)."

    case .invalidUrl(let url):
      return "Invalid url \(url)."
    }
  }
}
