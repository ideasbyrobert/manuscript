import Cascade
import ThemeDomain

package enum HighlightJS
{
    package static let highlighter = Highlighter(
        name: "highlight.js",
        containers: [
            "pre.hljs",
            "pre:has(> code.hljs)",
            "pre code.hljs",
            "code.hljs",
            ".hljs"
        ],
        bindings: bindings,
        resets: [
            Rule([".hljs-emphasis"], [Declaration("font-style", "italic")]),
            Rule([".hljs-strong"], [Declaration("font-weight", "700")]),
            Rule(
                [".hljs-addition", ".hljs-deletion"],
                [Declaration("background-color", "transparent")])
        ])

    private static let bindings: [TokenBinding] =
    [
        TokenBinding(
            [".hljs-comment", ".hljs-quote"],
            .comment,
            .italic),
        TokenBinding(
            [".hljs-keyword", ".hljs-selector-tag", ".hljs-doctag",
             ".hljs-literal"],
            .keyword,
            .bold),
        TokenBinding(
            [".hljs-type", ".hljs-title.class_",
             ".hljs-class .hljs-title", ".hljs-title.class_.inherited__"],
            .type),
        TokenBinding(
            [".hljs-title", ".hljs-title.function_",
             ".hljs-function .hljs-title", ".hljs-section",
             ".hljs-name", ".hljs-selector-id", ".hljs-selector-class",
             ".hljs-selector-attr", ".hljs-selector-pseudo"],
            .member),
        TokenBinding(
            [".hljs-string", ".hljs-regexp", ".hljs-attribute",
             ".hljs-meta .hljs-string", ".hljs-meta-string",
             ".hljs-code"],
            .string),
        TokenBinding([".hljs-char.escape_"], .alternateString),
        TokenBinding([".hljs-number"], .number),
        TokenBinding(
            [".hljs-meta", ".hljs-meta-keyword",
             ".hljs-meta .hljs-keyword", ".hljs-template-tag"],
            .preprocessor),
        TokenBinding(
            [".hljs-variable", ".hljs-template-variable", ".hljs-attr",
             ".hljs-property", ".hljs-params"],
            .alternateMember),
        TokenBinding(
            [".hljs-built_in", ".hljs-symbol", ".hljs-bullet",
             ".hljs-formula"],
            .alternateType),
        TokenBinding(
            [".hljs-operator", ".hljs-punctuation", ".hljs-subst",
             ".hljs-tag"],
            .operator),
        TokenBinding([".hljs-link"], .link),
        TokenBinding([".hljs-addition"], .addition),
        TokenBinding([".hljs-deletion"], .removal)
    ]
}
