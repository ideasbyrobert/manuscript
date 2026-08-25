import Foundation
import Testing
import WebKit

@testable import Web

@MainActor
@Suite("A page loaded in a view we own", .serialized)
struct NavigatorTests
{
    private func made() -> (WKWebView, Navigator)
    {
        let configuration = Configuration.make()
        configuration.setURLSchemeHandler(Hang(), forURLScheme: "hang")
        let web = Configuration.view(configuration)
        let navigator = Navigator()
        web.navigationDelegate = navigator
        return (web, navigator)
    }

    @Test("a page loads without a window or an application")
    func loadsHeadless() async throws
    {
        let (web, navigator) = made()
        try await within(.seconds(10))
        {
            try await navigator.load(
                html: "<html><body>ok</body></html>",
                base: URL(string: "https://manuscript.test/"),
                in: web)
        }
        #expect(navigator.document?.subject
            == URL(string: "https://manuscript.test/"))
    }

    @Test("only the newest load may publish; the first is superseded")
    func onlyTheNewest() async throws
    {
        let (web, navigator) = made()
        let slow = Task
        {
            try await navigator.load(
                URL(string: "hang://slow")!,
                in: web,
                within: .seconds(10))
        }
        try await Task.sleep(for: .milliseconds(150))
        try await within(.seconds(10))
        {
            try await navigator.load(
                html: "<html><body>new</body></html>",
                base: URL(string: "https://manuscript.test/new"),
                in: web)
        }
        await #expect(throws: WebError.superseded)
        {
            try await slow.value
        }
        #expect(navigator.document?.subject
            == URL(string: "https://manuscript.test/new"))
    }

    @Test("a load that never answers is abandoned at the watchdog")
    func watchdogAbandons() async throws
    {
        let (web, navigator) = made()
        await #expect(throws: WebError.timedOut)
        {
            try await navigator.load(
                URL(string: "hang://forever")!,
                in: web,
                within: .milliseconds(400))
        }
    }
}
