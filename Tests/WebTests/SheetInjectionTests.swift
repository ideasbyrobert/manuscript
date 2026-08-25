import Foundation
import Testing
import WebKit

@testable import Pigment
@testable import ThemeDomain
@testable import UserSheet
@testable import Web

@MainActor
@Suite("The sheet grounds the page it is given", .serialized)
struct SheetTests
{
    private func themed() throws -> (WKWebView, Navigator, Theme)
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
        return (web, navigator, pair.light)
    }

    private func background(_ selector: String, in web: WKWebView) async throws
        -> String
    {
        try await Evaluation.text(
            "getComputedStyle(document.querySelector(\"\(selector)\"))"
                + ".backgroundColor",
            in: web,
            world: Configuration.world)
    }

    private func rgb(_ colour: SRGB) -> String
    {
        let scaled = { (channel: Double) in Int((channel * 255).rounded()) }
        return "rgb(\(scaled(colour.red)), \(scaled(colour.green)), "
            + "\(scaled(colour.blue)))"
    }

    @Test("a grounded block takes our inset background on screen")
    func groundedBlockTakesInset() async throws
    {
        let (web, navigator, theme) = try themed()
        try await navigator.load(
            html: Fixture.page,
            base: URL(string: "https://manuscript.test/"),
            in: web)
        let found = try await background("#grounded", in: web)
        #expect(found == rgb(theme.palette[.insetBackground]), "\(found)")
    }

    @Test("an inline important background is the page's to keep")
    func inlineImportantIsThePage() async throws
    {
        let (web, navigator, _) = try themed()
        try await navigator.load(
            html: Fixture.page,
            base: URL(string: "https://manuscript.test/"),
            in: web)
        let found = try await background("#inline", in: web)
        #expect(found == "rgb(1, 2, 3)", "\(found)")
    }

    @Test("our floored sheet outranks a page important rule that carries an id")
    func flooredSheetBeatsPageImportant() async throws
    {
        let (web, navigator, theme) = try themed()
        try await navigator.load(
            html: Fixture.page,
            base: URL(string: "https://manuscript.test/"),
            in: web)
        let found = try await background("#contested", in: web)
        #expect(found == rgb(theme.palette[.insetBackground]), "\(found)")
    }
}
