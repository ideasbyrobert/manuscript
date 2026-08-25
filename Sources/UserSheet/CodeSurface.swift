import Cascade
import Highlighters
import ThemeDomain

package enum CodeSurface
{
    package static var blocks: [Block]
    {
        var rules: [Rule] = []
        for highlighter in HighlighterCatalog.all
        {
            rules.append(ground(highlighter))
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
                Declaration("color", TokenName.reference(.text)),
                Declaration("font-family", FontStack.mono)
            ])
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
                Declaration(
                    "background-color",
                    TokenName.reference(.cursorLine))
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
