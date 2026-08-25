import Foundation
import WebKit

package enum Sheet
{
    package static let elementID = "manuscript-sheet"

    package static func script(css: String) -> String
    {
        let quoted = String(
            decoding: try! JSONEncoder().encode(css),
            as: UTF8.self)
        return
        [
            "const source = \(quoted)",
            "function attach()",
            "{",
            "    if (document.getElementById(\"\(elementID)\"))",
            "    {",
            "        return",
            "    }",
            "    const style = document.createElement(\"style\")",
            "    style.id = \"\(elementID)\"",
            "    style.textContent = source",
            "    const root = document.head || document.documentElement",
            "    root.appendChild(style)",
            "}",
            "attach()",
            "document.addEventListener(\"DOMContentLoaded\", attach)",
            "window.addEventListener(\"load\", attach)"
        ]
        .joined(separator: "\n")
    }

    @MainActor
    package static func userScript(css: String) -> WKUserScript
    {
        WKUserScript(
            source: script(css: css),
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false,
            in: Configuration.world)
    }
}
