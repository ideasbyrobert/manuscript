import Cascade
import ThemeDomain

enum Prism
{
    static let highlighter = Highlighter(
        name: "Prism",
        containers: containers,
        bindings: bindings,
        resets: resets)

    private static let marks = ["language-", "lang-"]

    private static let containers = marks.flatMap
    {
        [
            "pre[class*=\"\($0)\"]",
            "pre:has(> code[class*=\"\($0)\"])",
            "code[class*=\"\($0)\"]"
        ]
    }

    private static let block = ":is("
        + marks.map { "[class*=\"\($0)\"]" }.joined(separator: ", ")
        + ")"

    private static func scoped(_ classes: [String]) -> [String]
    {
        classes.map { block + " " + $0 }
    }

    private static let resets: [Rule] =
    [
        Rule(
            marks.flatMap
            {
                ["pre[class*=\"\($0)\"]", "code[class*=\"\($0)\"]"]
            },
            [Declaration("text-shadow", "none")]),
        Rule(
            scoped([".token.operator", ".token.url", ".token.entity",
                    ".style .token.string"])
                + [".language-css .token.string"],
            [Declaration("background", "none")]),
        Rule(scoped([".token.namespace"]), [Declaration("opacity", "1")]),
        Rule(scoped([".token.bold"]), [Declaration("font-weight", "700")]),
        Rule(
            scoped([".token.italic"]),
            [Declaration("font-style", "italic")])
    ]

    private static let bindings: [TokenBinding] =
    [
        TokenBinding(
            scoped([".token.comment", ".token.prolog", ".token.doctype",
             ".token.cdata"]),
            .comment,
            .italic),
        TokenBinding(
            scoped([".token.keyword", ".token.atrule"]),
            .keyword,
            .bold),
        TokenBinding(scoped([".token.class-name"]), .type),
        TokenBinding(scoped([".token.function"]), .member),
        TokenBinding(
            scoped([".token.string", ".token.char", ".token.attr-value"]),
            .string),
        TokenBinding(
            scoped([".token.number", ".token.boolean", ".token.constant",
             ".token.symbol"]),
            .number),
        TokenBinding(
            scoped([".token.variable", ".token.regex", ".token.important"]),
            .alternateMember),
        TokenBinding(
            scoped([".token.tag", ".token.property", ".token.attr-name",
             ".token.selector", ".token.builtin"]),
            .alternateType),
        TokenBinding(
            scoped([".token.operator", ".token.url", ".token.entity"]),
            .operator),
        TokenBinding(scoped([".token.punctuation"]), .punctuation),
        TokenBinding(scoped([".token.inserted"]), .addition),
        TokenBinding(scoped([".token.deleted"]), .removal)
    ]
}
