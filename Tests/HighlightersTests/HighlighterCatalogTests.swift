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

    @Test("every highlighter can paint a block, not only a text run")
    func everyGroundReachesABlockElement()
    {
        for highlighter in HighlighterCatalog.all
        {
            let reachesPre = highlighter.containers.contains
            {
                $0.contains("pre")
            }
            #expect(
                reachesPre,
                "\(highlighter.name) grounds only a text run")
        }
    }
}
