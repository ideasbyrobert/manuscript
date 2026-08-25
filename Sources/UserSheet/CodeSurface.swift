import Cascade
import Highlighters
import ThemeDomain

enum CodeSurface
{
    static var blocks: [Block]
    {
        var rules: [Rule] = []
        for highlighter in HighlighterCatalog.all
        {
            rules.append(ground(highlighter))
            rules.append(flatten(highlighter))
            rules.append(contentsOf: highlighter.resets)
            rules.append(contentsOf: highlighter.bindings.map(paint))
        }
        rules.append(band)
        rules.append(bridge)
        return rules.map { Block.rule($0) }
    }

    private static func ground(_ highlighter: Highlighter) -> Rule
    {
        Rule(
            highlighter.containers,
            [
                Declaration(
                    "background-color",
                    TokenName.reference(.insetBackground)),
                Declaration("background-image", "none"),
                Declaration("color", TokenName.reference(.text)),
                Declaration("font-family", FontStack.mono)
            ])
    }

    private static func flatten(_ highlighter: Highlighter) -> Rule
    {
        Rule(
            highlighter.containers.map
            {
                $0 + " span[style*=\"color\"]:not([class])"
            },
            [Declaration("color", "inherit")])
    }

    private static func paint(_ binding: TokenBinding) -> Rule
    {
        var declarations =
        [
            Declaration("color", TokenName.reference(binding.role))
        ]
        switch binding.emphasis
        {
        case .none:
            break
        case .bold:
            declarations.append(Declaration("font-weight", "700"))
        case .italic:
            declarations.append(Declaration("font-style", "italic"))
        }
        return Rule(binding.selectors, declarations)
    }

    private static var band: Rule
    {
        Rule(
            Pygments.lineBands,
            [
                Declaration("background-color", "transparent"),
                Declaration(
                    "box-shadow",
                    "inset 3px 0 0 " + TokenName.reference(.keyword))
            ])
    }

    private static var bridge: Rule
    {
        Rule(
            [":root", "[data-color-mode]"],
            PrettyLights.bridges.map
            {
                Declaration($0.property, TokenName.reference($0.role))
            })
    }
}
