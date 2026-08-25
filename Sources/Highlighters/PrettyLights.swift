import ThemeDomain

package enum PrettyLights
{
    package static let bridges: [PropertyBridge] =
    [
        both("comment", .comment),
        both("constant", .number),
        both("entity", .member),
        both("storageModifierImport", .type),
        both("entityTag", .label),
        both("keyword", .keyword),
        both("string", .string),
        both("variable", .alternateMember),
        both("stringRegexp", .alternateString),
        both("markupInsertedText", .addition),
        both("markupDeletedText", .removal),
        both("markupChangedText", .modification),
        both("invalidIllegalText", .error),
        both("markupHeading", .type),
        both("constantOtherReferenceLink", .link),
        both("brackethighlighterAngle", .punctuation)
    ]
    .flatMap { $0 }

    private static func both(
        _ name: String,
        _ role: PaletteName) -> [PropertyBridge]
    {
        [
            PropertyBridge("--prettylights-syntax-" + name, role),
            PropertyBridge(
                "--color-prettylights-syntax-" + kebab(name),
                role)
        ]
    }

    private static func kebab(_ name: String) -> String
    {
        var result = ""
        for character in name
        {
            if character.isUppercase
            {
                result += "-" + character.lowercased()
            }
            else
            {
                result.append(character)
            }
        }
        return result
    }
}
