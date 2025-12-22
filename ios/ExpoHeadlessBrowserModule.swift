import ExpoModulesCore
import WebKit

public class ExpoHeadlessBrowserModule: Module {

  private let sessions = SessionManager()

  public func definition() -> ModuleDefinition {
    Name("ExpoHeadlessBrowser")

    AsyncFunction("createSessionAsync") { () async throws -> String in 
        return await self.sessions.create()
    }
    
    AsyncFunction("closeSessionAsync") { (sessionId: String) async throws -> Bool in
        return try await self.sessions.close(sessionId: sessionId)
    }
    
    AsyncFunction("reloadAsync") { (sessionId: String) async throws -> Bool in
        return try await self.sessions.reload(sessionId: sessionId)
    }

    AsyncFunction("navigateAsync") { (sessionId: String, url: String) async throws -> Bool in
        return try await self.sessions.navigate(sessionId: sessionId, url: url)
    }

    AsyncFunction("getTitleAsync") { (sessionId: String) async throws -> String? in
        return try await self.sessions.getTitle(sessionId: sessionId)
    }

    AsyncFunction("getCurrentUrlAsync") { (sessionId: String) async throws -> String? in
        return try await self.sessions.getCurrentUrl(sessionId: sessionId)
    }

    AsyncFunction("executeScriptAsync") { (sessionId: String, script: String) async throws -> String? in
        return try await self.sessions.executeScript(sessionId: sessionId, script: script)
    }

    AsyncFunction("getElementByCssAsync") { (sessionId: String, selector: String) async throws -> String? in
        return try await self.sessions.getElementByCss(sessionId: sessionId, selector: selector)
    }

    AsyncFunction("getElementsByCssAsync") { (sessionId: String, selector: String) async throws -> String? in
        return try await self.sessions.getElementsByCss(sessionId: sessionId, selector: selector)
    }

    AsyncFunction("getPageHtmlAsync") { (sessionId: String) async throws -> String? in
        return try await self.sessions.dumpHtml(sessionId: sessionId)
    }

    AsyncFunction("getElementByClassNameAsync") { (sessionId: String, className: String) async throws -> String? in
        return try await self.sessions.getElementByClassName(sessionId: sessionId, className: className)
    }
    
    AsyncFunction("getElementsByClassNameAsync") { (sessionId: String, className: String) async throws -> String? in
        return try await self.sessions.getElementsByClassName(sessionId: sessionId, className: className)
    }

    AsyncFunction("getElementByIdAsync") { (sessionId: String, elementId: String) async throws -> String? in
        return try await self.sessions.getElementById(sessionId: sessionId, elementId: elementId)
    }

    AsyncFunction("findElementByTextAsync") { (sessionId: String, query: String) async throws -> String? in
        return try await self.sessions.findElementByText(sessionId: sessionId, query: query)
    }

    AsyncFunction("elementGetTextAsync") { (sessionId: String, elementId: String) async throws -> String? in
        return try await self.sessions.elementGetText(sessionId: sessionId, elementId: elementId)
    }

    AsyncFunction("elementGetAttributeNameAsync") { (sessionId: String, elementId: String, attributeName: String) async throws -> String? in
        return try await self.sessions.elementGetAttribute(sessionId: sessionId, elementId: elementId, attributeName: attributeName)
    }

    AsyncFunction("elementClickAsync") { (sessionId: String, elementId: String) async throws -> Bool in
        return try await self.sessions.elementClick(sessionId: sessionId, elementId: elementId)
    }

    AsyncFunction("wait") { (milliseconds: Double) async throws -> Bool in
        return try await self.sessions.wait(milliseconds: milliseconds)
    }

    AsyncFunction("waitForElement") { (sessionId: String, selector: String, timeout: Double) async throws -> String? in
      return try await self.sessions.waitForElement(sessionId: sessionId, selector: selector, timeout: timeout)
    }

  }
}
