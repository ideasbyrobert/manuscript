import Foundation
import Testing
import WebKit

@testable import Web

@MainActor
@Suite("Reading a value back out of a page", .serialized)
struct EvaluationTests
{
    private struct Shape: Decodable, Equatable
    {
        let text: String
        let count: Int
    }

    private func loaded() async throws -> WKWebView
    {
        let web = Configuration.view(Configuration.make())
        let navigator = Navigator()
        web.navigationDelegate = navigator
        try await navigator.load(
            html: "<html><body><p>a</p><p>b</p></body></html>",
            base: URL(string: "https://manuscript.test/"),
            in: web)
        return web
    }

    @Test("a string comes back as a string")
    func aString() async throws
    {
        let web = try await loaded()
        let text = try await Evaluation.text(
            "document.querySelectorAll('p').length + ''",
            in: web,
            world: Configuration.world)
        #expect(text == "2")
    }

    @Test("a JSON document decodes to a typed value")
    func aDocument() async throws
    {
        let web = try await loaded()
        let script =
            "JSON.stringify({text: document.body.children[0].textContent,"
            + " count: document.querySelectorAll('p').length})"
        let shape = try await Evaluation.read(
            Shape.self,
            script,
            in: web,
            world: Configuration.world)
        #expect(shape == Shape(text: "a", count: 2))
    }

    @Test("a value that is not text is refused")
    func notText() async throws
    {
        let web = try await loaded()
        await #expect(throws: WebError.notText)
        {
            try await Evaluation.text(
                "42",
                in: web,
                world: Configuration.world)
        }
    }
}
