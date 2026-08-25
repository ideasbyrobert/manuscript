import Testing

@testable import Cascade
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

    @Test("every selector closes what it opens")
    func everySelectorParses()
    {
        for highlighter in HighlighterCatalog.all
        {
            for selector in Self.selectors(of: highlighter)
            {
                #expect(
                    Self.closes(selector),
                    "\(highlighter.name) loses a rule to \(selector)")
            }
        }
    }

    private static func selectors(
        of highlighter: Highlighter) -> [String]
    {
        highlighter.containers
            + highlighter.bindings.flatMap { $0.selectors }
            + highlighter.resets.flatMap { $0.selectors }
    }

    private static func closes(_ selector: String) -> Bool
    {
        var quoted = false
        var brackets = 0
        var parentheses = 0
        for character in selector
        {
            if character == "\""
            {
                quoted.toggle()
                continue
            }
            if quoted
            {
                continue
            }
            switch character
            {
            case "[":
                brackets += 1
            case "]":
                brackets -= 1
            case "(":
                parentheses += 1
            case ")":
                parentheses -= 1
            default:
                break
            }
            if brackets < 0 || parentheses < 0
            {
                return false
            }
        }
        return !quoted && brackets == 0 && parentheses == 0
    }

    @Test("every token that ships its own ground has it dealt with")
    func everyPaintedTokenIsNeutralised()
    {
        let painted =
        [
            ".hljs-addition", ".hljs-deletion",
            " .err", " .gd", " .gi",
            " .token.operator", " .token.url", " .token.entity"
        ]
        let neutralised = HighlighterCatalog.all
            .flatMap { $0.resets }
            .filter
            { rule in
                rule.declarations.contains
                {
                    $0.property.hasPrefix("background")
                }
            }
            .flatMap { $0.selectors }
        for selector in painted
        {
            #expect(
                neutralised.contains { $0.hasSuffix(selector) },
                "\(selector) keeps the ground its own theme painted")
        }
    }
}
