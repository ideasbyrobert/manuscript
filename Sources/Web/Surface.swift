import AppKit
import Foundation
import WebKit

@MainActor
package final class Surface
{
    package let window: NSWindow
    package let web: WKWebView
    private let navigator = Navigator()

    package init(css: String)
    {
        let configuration = Configuration.make()
        configuration.userContentController.addUserScript(
            Sheet.userScript(css: css))
        web = Configuration.view(configuration)
        web.navigationDelegate = navigator
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 720, height: 540),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false)
        window.title = "Manuscript"
        window.contentView = web
    }

    package func show()
    {
        window.center()
        window.makeKeyAndOrderFront(nil)
    }

    package func present(html: String, base: URL?) async throws
    {
        try await navigator.load(html: html, base: base, in: web)
    }

    package func present(_ url: URL) async throws
    {
        try await navigator.load(url, in: web)
    }

    package func snapshot() async throws -> NSImage
    {
        try await web.takeSnapshot(configuration: WKSnapshotConfiguration())
    }
}
