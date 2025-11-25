extension SessionManager {
    func getElementByCss(sessionId: String, selector: String) async throws -> String? {
        let escaped = selector
            .replacingOccurrences(of: "'", with: "\\'")
            .replacingOccurrences(of: "\n", with: " ")

        let script = """
            (function() {
                try {
                  const el = document.querySelector('\(escaped)');
                  return window.__expoWD.toId(el);
                } catch (e) {
                  return null;
                }
              })();
            """
        
        return try await executeScript(sessionId: sessionId, script: script)
    }
    
    func getElementsByCss(sessionId: String, selector: String) async throws -> [String] {
        let escaped = selector
          .replacingOccurrences(of: "'", with: "\\'")
          .replacingOccurrences(of: "\n", with: " ")
        
        let script = """
          (function() {
            try {
              const els = document.querySelectorAll('\(escaped)');
              return Array.from(els).map(el => window.__expoWD.toId(el));
            } catch (e) {
              return [];
            }
          })();
        """
        
        return try await executeScript(sessionId: sessionId, script: script)
    }
    
    func getElementByClassName(sessionId: String, className: String) async throws -> String? {
        let escaped = className.replacingOccurrences(of: "'", with: "\\'")
        
        let script = """
        (function(){
          const el = document.getElementsByClassName('\(escaped)')[0];
          return window.__expoWD.toId(el);
        })();
        """
        
        return try await executeScript(sessionId: sessionId, script: script)
    }
    
    func getElementsByClassName(sessionId: String, className: String) async throws -> [String] {
        let escaped = className.replacingOccurrences(of: "'", with: "\\'")
        
        let script = """
          (function() {
            try {
              const els = document.getElementsByClassName('\(escaped)');
              return Array.from(els).map(el => window.__expoWD.toId(el));
            } catch (e) {
              return [];
            }
          })();
        """
        
        return try await executeScript(sessionId: sessionId, script: script)
    }
    
    func findElementByText(sessionId: String, query: String) async throws -> String? {
        let escaped = query
          .replacingOccurrences(of: "'", with: "\\'")
          .replacingOccurrences(of: "\n", with: " ")

        let script = """
          (function() {
            const needle = '\(escaped)'.toLowerCase();

            const walker = document.createTreeWalker(
              document.body,
              NodeFilter.SHOW_ELEMENT,
              null,
              false
            );

            let node;
            while (node = walker.nextNode()) {
              const txt = (node.innerText || node.textContent || '').toLowerCase();
              if (txt.includes(needle)) {
                return window.__expoWD.toId(node);
              }
            }
            return null;
          })();
        """
        
        return try await executeScript(sessionId: sessionId, script: script)
    }

    func getElementById(sessionId: String, elementId: String) async throws -> String? {
        let escaped = elementId.replacingOccurrences(of: "'", with: "\\'")
        
        let script = """
        (function(){
          const el = document.getElementById('\(escaped)');
          return window.__expoWD.toId(el);
        })();
        """
        
        return try await executeScript(sessionId: sessionId, script: script)
    }
    
    func elementGetText(sessionId: String, elementId: String) async throws -> String? {
        let escaped = elementId.replacingOccurrences(of: "'", with: "\\'")

        let script = """
          (function() {
            const el = window.__expoWD.byId('\(escaped)');
            if (!el) return null;
            return el.innerText || el.textContent || null;
          })();
        """
        
        return try await executeScript(sessionId: sessionId, script: script)
    }

    func elementGetAttribute(sessionId: String, elementId: String, attributeName: String) async throws -> String? {
      let escapedId = elementId.replacingOccurrences(of: "'", with: "\\'")
      let escapedAttributeName = attributeName.replacingOccurrences(of: "'", with: "\\'")

      let script = """
        (function() {
          const el = window.__expoWD.byId('\(escapedId)');
          if (!el) return null;
          const v = el.getAttribute('\(escapedAttributeName)');
          return v === null ? null : String(v);
        })();
      """

      return try await executeScript(sessionId: sessionId, script: script)
    }

    func elementClick(sessionId: String, elementId: String) async throws -> Bool {
        let escaped = elementId.replacingOccurrences(of: "'", with: "\\'")
        
        let script = """
          (function() {
            const el = window.__expoWD.byId('\(escaped)');
            if (!el) return false;

            const rect = el.getBoundingClientRect();
            const centerX = rect.left + rect.width / 2;
            const centerY = rect.top + rect.height / 2;

            function fire(type) {
              const evt = new MouseEvent(type, {
                view: window,
                bubbles: true,
                cancelable: true,
                clientX: centerX,
                clientY: centerY
              });
              el.dispatchEvent(evt);
            }

            el.focus && el.focus();
            fire("mousedown");
            fire("mouseup");
            fire("click");

            return true;
          })();
        """
        
        return try await executeScript(sessionId: sessionId, script: script) as Bool
    }
    
    func setElementText(sessionId: String, elementId: String, text: String) async throws -> Bool {
        let escapedId = elementId.replacingOccurrences(of: "'", with: "\\'")
        
        let escapedText = text
            .replacingOccurrences(of: "'", with: "\\'")
            .replacingOccurrences(of: "\n", with: " ")

        let script = """
          (function() {
            const el = window.__expoWD.byId('\(escapedId)');
            if (!el) return false;
            el.innerText = '\(escapedText)';
            return true;
          })();
        """
        
        return try await executeScript(sessionId: sessionId, script: script) as Bool
    }
    
}
