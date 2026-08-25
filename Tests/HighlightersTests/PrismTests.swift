import Testing

@testable import Highlighters

@Suite("What Prism marks a block with")
struct PrismTests
{
    private var containers: [String]
    {
        Prism.highlighter.containers
    }

    private var tokens: [String]
    {
        Prism.highlighter.bindings.flatMap { $0.selectors }
    }

    @Test("both spellings of the language mark ground a block",
          arguments: ["language-", "lang-"])
    func bothMarksAreGrounded(mark: String)
    {
        #expect(containers.contains("pre[class*=\"\(mark)\"]"))
        #expect(containers.contains("code[class*=\"\(mark)\"]"))
        #expect(containers.contains("pre:has(> code[class*=\"\(mark)\"])"))
    }

    @Test("a brush is not a Prism mark")
    func noBrushIsGrounded()
    {
        #expect(!containers.contains { $0.contains("brush") })
    }

    @Test("a token is reached only inside a marked block")
    func everyTokenIsScopedToABlock()
    {
        for selector in tokens
        {
            #expect(
                selector.hasPrefix(":is([class*=\"language-\"]"),
                "\(selector) would reach any element on the page")
        }
    }

    @Test("the core roles are all bound",
          arguments: [".token.keyword", ".token.string", ".token.comment",
                      ".token.number", ".token.function",
                      ".token.class-name", ".token.punctuation",
                      ".token.operator"])
    func coreTokensAreBound(token: String)
    {
        #expect(
            tokens.contains { $0.hasSuffix(" " + token) },
            "\(token) keeps whatever colour the page gave it")
    }
}
