import Testing

@testable import Highlighters
@testable import ThemeDomain

@Suite("What highlight.js leaves to the page")
struct HighlightJSTests
{
    private static let coloured =
    [
        ".hljs-keyword", ".hljs-string", ".hljs-comment", ".hljs-number",
        ".hljs-title", ".hljs-type", ".hljs-built_in", ".hljs-attr",
        ".hljs-variable", ".hljs-meta", ".hljs-tag", ".hljs-template-tag",
        ".hljs-code", ".hljs-selector-attr", ".hljs-selector-pseudo",
        ".hljs-formula", ".hljs-char.escape_", ".hljs-addition",
        ".hljs-deletion", ".hljs-link", ".hljs-symbol", ".hljs-literal",
        ".hljs-section", ".hljs-name"
    ]

    private static func role(of selector: String) -> PaletteName?
    {
        HighlightJS.highlighter.bindings
            .first { $0.selectors.contains(selector) }?
            .role
    }

    @Test("every class a shipped theme colours is bound",
          arguments: HighlightJSTests.coloured)
    func theColouredClassesAreBound(selector: String)
    {
        #expect(
            HighlightJSTests.role(of: selector) != nil,
            "\(selector) keeps whatever colour the page gave it")
    }

    @Test("a template tag is not a template variable")
    func templateDelimitersStayDistinct()
    {
        let tag = HighlightJSTests.role(of: ".hljs-template-tag")
        let variable = HighlightJSTests.role(of: ".hljs-template-variable")
        #expect(tag != nil)
        #expect(variable != nil)
        #expect(tag != variable, "Jinja braces would collapse to one hue")
    }

    @Test("the markup skeleton is not left darker than its contents")
    func theTagItselfIsColoured()
    {
        #expect(HighlightJSTests.role(of: ".hljs-tag") != nil)
        #expect(HighlightJSTests.role(of: ".hljs-name") != nil)
    }
}
