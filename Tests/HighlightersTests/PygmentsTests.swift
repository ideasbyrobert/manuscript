import Testing

@testable import Cascade
@testable import Highlighters

@Suite("Where Pygments and Chroma put the block")
struct PygmentsTests
{
    private static let wrappers = [".highlight", ".chroma", ".codehilite"]

    private var containers: [String]
    {
        Pygments.highlighter.containers
    }

    @Test("a wrapper is grounded whether it holds the block or is one",
          arguments: PygmentsTests.wrappers)
    func everyWrapperIsGroundedBothWays(wrapper: String)
    {
        #expect(
            containers.contains(wrapper + ":has(> pre)"),
            "a div or figure wearing \(wrapper) keeps the page's ground")
        #expect(
            containers.contains("pre" + wrapper),
            "a pre wearing \(wrapper) is left unpainted")
    }

    @Test("a bare wrapper class never grounds anything",
          arguments: PygmentsTests.wrappers)
    func aBareWrapperIsNeverAContainer(wrapper: String)
    {
        #expect(
            !containers.contains(wrapper),
            "\(wrapper) would reach any element wearing that name")
    }

    @Test("every wrapper scopes its own pre and code")
    func everyWrapperScopesItsContents()
    {
        for wrapper in PygmentsTests.wrappers
        {
            #expect(containers.contains(wrapper + " pre"))
            #expect(containers.contains(wrapper + " code"))
        }
    }
    @Test("every class a shipped Pygments theme colours is bound")
    func theColouredClassesAreBound()
    {
        let bound = Set(
            Pygments.highlighter.bindings.flatMap { $0.selectors })
        for token in [
            ".k", ".kd", ".s", ".c", ".c1", ".m", ".mi", ".nf", ".nc",
            ".nb", ".nt", ".na", ".nv", ".o", ".p", ".se", ".cp",
            ".gh", ".gu", ".gp", ".go", ".gi", ".gd", ".err"]
        {
            #expect(
                bound.contains { $0.hasSuffix(" " + token) },
                "\(token) keeps whatever colour the page gave it")
        }
    }

    @Test("a token is reached only through a block, never a bare wrapper")
    func everyTokenIsScopedToABlock()
    {
        let selectors = Pygments.highlighter.bindings
            .flatMap { $0.selectors }
            + Pygments.highlighter.resets.flatMap { $0.selectors }
            + Pygments.lineBands
        for selector in selectors
        {
            #expect(
                selector.contains("pre"),
                "\(selector) would reach any element in a .highlight")
        }
    }

    @Test("a line-number gutter is grounded and its numbers made faint")
    func theGutterIsGroundedAndFaint()
    {
        for gutter in [".highlighttable", "td.linenos pre", ".linenodiv pre",
                       ".chroma .lntd"]
        {
            #expect(containers.contains(gutter), "\(gutter) keeps the page")
        }
        let faint = Pygments.highlighter.bindings
            .first { $0.role == .faintText }?
            .selectors ?? []
        for numbers in [" .lnt", " .ln", " .linenos", "td.linenos pre"]
        {
            #expect(
                faint.contains { $0.hasSuffix(numbers) },
                "\(numbers) keeps the site's colour on our ground")
        }
    }
}
