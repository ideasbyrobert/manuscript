import Foundation
import Testing
import WebKit

@testable import ThemeDomain
@testable import UserSheet
@testable import Web

@MainActor
@Suite(
    "The live web, when asked",
    .serialized,
    .enabled(if:
        ProcessInfo.processInfo.environment["MANUSCRIPT_LIVE"] == "1"))
struct CorpusTests
{
    private func read(_ page: Corpus.Page) async throws -> Reading
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
        try await navigator.load(page.url, in: web, within: .seconds(40))
        try await Task.sleep(for: .milliseconds(400))
        return try await Evaluation.read(
            Reading.self,
            Harness.script,
            in: web,
            world: Configuration.world)
    }

    @Test(arguments: Corpus.pages)
    func groundsWithoutHarm(_ page: Corpus.Page) async throws
    {
        let reading = try await read(page)
        #expect(reading.collateral == 0, "\(page.family): \(reading)")
        #expect(reading.orphan == 0, "\(page.family): \(reading)")
        if page.covers
        {
            #expect(reading.grounded == reading.blocks,
                "\(page.family): \(reading)")
            if reading.spans > 0
            {
                #expect(reading.worst >= 3.0, "\(page.family): \(reading)")
            }
        }
        else
        {
            #expect(reading.grounded == 0, "\(page.family): \(reading)")
        }
    }
}
