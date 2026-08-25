import Foundation
import Testing
import WebKit

@testable import ThemeDomain
@testable import UserSheet
@testable import Web

@MainActor
@Suite("The fixture read through the harness", .serialized)
struct HarnessTests
{
    private func read(_ html: String) async throws -> Reading
    {
        let pair = try #require(
            ThemePair.all(in: Theme.catalogue())
                .first { $0.name == "ember" })
        let configuration = Configuration.make()
        configuration.userContentController.addUserScript(
            Sheet.userScript(css: AuthorSheet.text(for: pair)))
        let web = Configuration.view(configuration)
        let navigator = Navigator()
        web.navigationDelegate = navigator
        try await navigator.load(
            html: html,
            base: URL(string: "https://manuscript.test/"),
            in: web)
        return try await Evaluation.read(
            Reading.self,
            Harness.script,
            in: web,
            world: Configuration.world)
    }

    @Test("it grounds the blocks it knows and leaves the page's alone")
    func groundsAndLeaves() async throws
    {
        let reading = try await read(Fixture.page)
        #expect(reading.blocks == 6, "\(reading)")
        #expect(reading.grounded == 5, "\(reading)")
        #expect(reading.ungrounded == 1, "\(reading)")
    }

    @Test("no selector of ours matches outside a code block")
    func noCollateral() async throws
    {
        let reading = try await read(Fixture.page)
        #expect(reading.collateral == 0, "\(reading)")
    }

    @Test("the worst contrast among tokens meets the floor of three")
    func worstMeetsFloor() async throws
    {
        let reading = try await read(Fixture.page)
        #expect(reading.spans > 0, "\(reading)")
        #expect(reading.worst >= 3.0, "\(reading)")
        #expect(reading.under == 0, "\(reading)")
    }
}
