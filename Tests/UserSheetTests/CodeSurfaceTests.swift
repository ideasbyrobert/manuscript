import Testing

@testable import Cascade
@testable import Highlighters
@testable import UserSheet

@Suite("Where the model becomes rules")
struct CodeSurfaceTests
{
    private static var rules: [Rule]
    {
        CodeSurface.blocks.compactMap
        {
            if case .rule(let rule) = $0
            {
                return rule
            }
            return nil
        }
    }

    @Test("a token painted inline and carrying no class takes our ink",
          arguments: HighlighterCatalog.all)
    func inlineColourIsFlattened(highlighter: Highlighter)
    {
        let flattened = Self.rules
            .filter(Self.flattens)
            .flatMap { $0.selectors }
        for container in highlighter.containers
        {
            let expected = container
                + " span[style*=\"color\"]:not([class])"
            #expect(
                flattened.contains(expected),
                "\(highlighter.name) leaves inline colour on its ground")
        }
    }

    @Test("a token that carries a class keeps its binding")
    func classedTokensAreNotFlattened()
    {
        for rule in Self.rules where Self.flattens(rule)
        {
            for selector in rule.selectors
            {
                #expect(
                    selector.hasSuffix(":not([class])"),
                    "\(selector) would erase a bound token's colour")
            }
        }
    }

    private static func flattens(_ rule: Rule) -> Bool
    {
        rule.declarations.count == 1
            && rule.declarations[0].property == "color"
            && rule.declarations[0].value == "inherit"
    }

    @Test("a ground takes the surface, the image over it, the ink and the face",
          arguments: HighlighterCatalog.all)
    func aGroundCarriesEveryDeclarationItNeeds(highlighter: Highlighter)
    {
        let ground = Self.rules.first
        {
            $0.selectors == highlighter.containers
        }
        let properties = ground?.declarations.map { $0.property } ?? []
        #expect(
            properties == [
                "background-color", "background-image", "color",
                "font-family"],
            "\(highlighter.name) grounds with \(properties)")
        let image = ground?.declarations
            .first { $0.property == "background-image" }
        #expect(image?.value == "none")
    }

    @Test("an emphasis becomes the property it names, and only that one")
    func emphasisReachesItsProperty()
    {
        let hljs = HighlightJS.highlighter
        func painted(_ emphasis: Emphasis) -> [String: String]
        {
            let binding = hljs.bindings.first { $0.emphasis == emphasis }
            let rule = Self.rules.first { $0.selectors == binding?.selectors }
            var found: [String: String] = [:]
            for declaration in rule?.declarations ?? []
            {
                found[declaration.property] = declaration.value
            }
            return found
        }
        let italic = painted(.italic)
        let bold = painted(.bold)
        let plain = painted(.none)
        #expect(italic["font-style"] == "italic")
        #expect(italic["font-weight"] == nil)
        #expect(bold["font-weight"] == "700")
        #expect(bold["font-style"] == nil)
        #expect(plain.count == 1 && plain["color"] != nil)
    }

    @Test("a ground is stated before any token it holds",
          arguments: HighlighterCatalog.all)
    func theGroundComesFirst(highlighter: Highlighter)
    {
        let all = Self.rules
        let ground = all.firstIndex { $0.selectors == highlighter.containers }
        let token = highlighter.bindings.first?.selectors
        let painted = all.firstIndex { $0.selectors == token }
        #expect(ground != nil && painted != nil)
        #expect((ground ?? 0) < (painted ?? 0), "\(highlighter.name)")
    }
}
