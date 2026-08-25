import Cascade
import ThemeDomain

enum Prism
{
    static let highlighter = Highlighter(
        name: "Prism",
        containers: [
            "pre[class*=\"language-\"]",
            "pre:has(> code[class*=\"language-\"])",
            "code[class*=\"language-\"]",
            "pre[class*=\"brush:\"]"
        ],
        bindings: bindings,
        resets: resets)

    private static let resets: [Rule] =
    [
        Rule(
            ["pre[class*=\"language-\"]", "code[class*=\"language-\"]"],
            [Declaration("text-shadow", "none")]),
        Rule(
            [".token.operator", ".token.url", ".token.entity",
             ".language-css .token.string", ".style .token.string"],
            [Declaration("background", "none")]),
        Rule([".token.namespace"], [Declaration("opacity", "1")]),
        Rule([".token.bold"], [Declaration("font-weight", "700")]),
        Rule([".token.italic"], [Declaration("font-style", "italic")])
    ]

    private static let bindings: [TokenBinding] =
    [
        TokenBinding(
            [".token.comment", ".token.prolog", ".token.doctype",
             ".token.cdata"],
            .comment,
            .italic),
        TokenBinding(
            [".token.keyword", ".token.atrule"],
            .keyword,
            .bold),
        TokenBinding([".token.class-name"], .type),
        TokenBinding([".token.function"], .member),
        TokenBinding(
            [".token.string", ".token.char", ".token.attr-value"],
            .string),
        TokenBinding(
            [".token.number", ".token.boolean", ".token.constant",
             ".token.symbol"],
            .number),
        TokenBinding(
            [".token.variable", ".token.regex", ".token.important"],
            .alternateMember),
        TokenBinding(
            [".token.tag", ".token.property", ".token.attr-name",
             ".token.selector", ".token.builtin"],
            .alternateType),
        TokenBinding(
            [".token.operator", ".token.url", ".token.entity"],
            .operator),
        TokenBinding([".token.punctuation"], .punctuation),
        TokenBinding([".token.inserted"], .addition),
        TokenBinding([".token.deleted"], .removal)
    ]
}
