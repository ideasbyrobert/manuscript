import Testing

@testable import Highlighters

@Suite("What the web calls its tokens")
struct HighlighterCatalogTests
{
    @Test("every highlighter names a container to paint")
    func everyHighlighterHasAContainer()
    {
        for highlighter in HighlighterCatalog.all
        {
            #expect(
                !highlighter.containers.isEmpty,
                "\(highlighter.name) paints nothing")
        }
    }

    @Test("no binding is left without a selector")
    func everyBindingSelectsSomething()
    {
        for highlighter in HighlighterCatalog.all
        {
            for binding in highlighter.bindings
            {
                #expect(
                    !binding.selectors.isEmpty,
                    "\(highlighter.name) binds \(binding.role) to nothing")
            }
        }
    }

    @Test("a selector is claimed by one role only")
    func noSelectorIsClaimedTwice()
    {
        for highlighter in HighlighterCatalog.all
        {
            var seen: Set<String> = []
            for binding in highlighter.bindings
            {
                for selector in binding.selectors
                {
                    #expect(
                        seen.insert(selector).inserted,
                        "\(highlighter.name) repeats \(selector)")
                }
            }
        }
    }

    @Test("every highlighter grounds a block, not a run of text")
    func everyGroundReachesABlockElement()
    {
        for highlighter in HighlighterCatalog.all
        {
            let grounded = highlighter.containers.contains
            {
                Self.subject(of: $0).hasPrefix("pre")
            }
            #expect(grounded, "\(highlighter.name) grounds no block")
        }
    }

    @Test("a descendant selector does not count as grounding a block")
    func theSubjectIsTheRightmostCompound()
    {
        #expect(Self.subject(of: "pre code.hljs") == "code.hljs")
        #expect(Self.subject(of: "pre.hljs") == "pre.hljs")
        #expect(Self.subject(of: "pre:has(> code.hljs)") == "pre:has")
        #expect(Self.subject(of: ".highlight pre") == "pre")
        #expect(Self.subject(of: ".chroma") == ".chroma")
    }

    private static func subject(of selector: String) -> String
    {
        var depth = 0
        var flat = ""
        for character in selector
        {
            if character == "("
            {
                depth += 1
                continue
            }
            if character == ")"
            {
                depth -= 1
                continue
            }
            if depth == 0
            {
                flat.append(character)
            }
        }
        let parts = flat.split
        {
            $0 == " " || $0 == ">"
        }
        return String(parts.last ?? "")
    }
}
