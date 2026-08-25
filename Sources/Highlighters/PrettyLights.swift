import ThemeDomain

package enum PrettyLights
{
    package static let bridges: [PropertyBridge] =
    [
        both("comment", "comment", .comment),
        both("constant", "constant", .number),
        both("entity", "entity", .member),
        both(
            "storageModifierImport",
            "storage-modifier-import",
            .type),
        both("entityTag", "entity-tag", .label),
        both("keyword", "keyword", .keyword),
        both("string", "string", .string),
        both("variable", "variable", .alternateMember),
        both("stringRegexp", "string-regexp", .alternateString),
        both("markup-inserted-text", "markup-inserted-text", .addition),
        both("markup-deleted-text", "markup-deleted-text", .removal),
        both(
            "markup-changed-text",
            "markup-changed-text",
            .modification),
        both("invalidIllegal-text", "invalid-illegal-text", .error),
        both("markup-heading", "markup-heading", .type),
        both(
            "constantOtherReferenceLink",
            "constant-other-reference-link",
            .link),
        both(
            "bracketHighlighterAngle",
            "brackethighlighter-angle",
            .punctuation)
    ]
    .flatMap { $0 }

    private static func both(
        _ name: String,
        _ legacy: String,
        _ role: PaletteName) -> [PropertyBridge]
    {
        [
            PropertyBridge("--prettylights-syntax-" + name, role),
            PropertyBridge(
                "--color-prettylights-syntax-" + legacy,
                role)
        ]
    }
}
