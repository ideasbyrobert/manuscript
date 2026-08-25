import Testing

@testable import Highlighters

@Suite("The names GitHub actually publishes")
struct PrettyLightsTests
{
    private static let published: Set<String> =
    [
        "--color-prettylights-syntax-brackethighlighter-angle",
        "--color-prettylights-syntax-brackethighlighter-unmatched",
        "--color-prettylights-syntax-carriage-return-bg",
        "--color-prettylights-syntax-carriage-return-text",
        "--color-prettylights-syntax-comment",
        "--color-prettylights-syntax-constant",
        "--color-prettylights-syntax-constant-other-reference-link",
        "--color-prettylights-syntax-entity",
        "--color-prettylights-syntax-entity-tag",
        "--color-prettylights-syntax-invalid-illegal-bg",
        "--color-prettylights-syntax-invalid-illegal-text",
        "--color-prettylights-syntax-keyword",
        "--color-prettylights-syntax-markup-bold",
        "--color-prettylights-syntax-markup-changed-bg",
        "--color-prettylights-syntax-markup-changed-text",
        "--color-prettylights-syntax-markup-deleted-bg",
        "--color-prettylights-syntax-markup-deleted-text",
        "--color-prettylights-syntax-markup-heading",
        "--color-prettylights-syntax-markup-ignored-bg",
        "--color-prettylights-syntax-markup-ignored-text",
        "--color-prettylights-syntax-markup-inserted-bg",
        "--color-prettylights-syntax-markup-inserted-text",
        "--color-prettylights-syntax-markup-italic",
        "--color-prettylights-syntax-markup-list",
        "--color-prettylights-syntax-meta-diff-range",
        "--color-prettylights-syntax-storage-modifier-import",
        "--color-prettylights-syntax-string",
        "--color-prettylights-syntax-string-regexp",
        "--color-prettylights-syntax-sublimelinter-gutter-mark",
        "--color-prettylights-syntax-variable",
        "--prettylights-syntax-bracketHighlighterAngle",
        "--prettylights-syntax-bracketHighlighterUnmatched",
        "--prettylights-syntax-brackethighlighter-angle",
        "--prettylights-syntax-brackethighlighter-unmatched",
        "--prettylights-syntax-carriage-return-bg",
        "--prettylights-syntax-carriage-return-text",
        "--prettylights-syntax-carriageReturn-bg",
        "--prettylights-syntax-carriageReturn-text",
        "--prettylights-syntax-comment", "--prettylights-syntax-constant",
        "--prettylights-syntax-constant-other-reference-link",
        "--prettylights-syntax-constantOtherReferenceLink",
        "--prettylights-syntax-entity", "--prettylights-syntax-entity-tag",
        "--prettylights-syntax-entityTag",
        "--prettylights-syntax-invalid-illegal-bg",
        "--prettylights-syntax-invalid-illegal-text",
        "--prettylights-syntax-invalidIllegal-bg",
        "--prettylights-syntax-invalidIllegal-text",
        "--prettylights-syntax-keyword", "--prettylights-syntax-markup-bold",
        "--prettylights-syntax-markup-changed-bg",
        "--prettylights-syntax-markup-changed-text",
        "--prettylights-syntax-markup-deleted-bg",
        "--prettylights-syntax-markup-deleted-text",
        "--prettylights-syntax-markup-heading",
        "--prettylights-syntax-markup-ignored-bg",
        "--prettylights-syntax-markup-ignored-text",
        "--prettylights-syntax-markup-inserted-bg",
        "--prettylights-syntax-markup-inserted-text",
        "--prettylights-syntax-markup-italic",
        "--prettylights-syntax-markup-list",
        "--prettylights-syntax-meta-diff-range",
        "--prettylights-syntax-metaDiffRange",
        "--prettylights-syntax-storage-modifier-import",
        "--prettylights-syntax-storageModifierImport",
        "--prettylights-syntax-string", "--prettylights-syntax-string-regexp",
        "--prettylights-syntax-stringRegexp",
        "--prettylights-syntax-sublimeLinterGutterMark",
        "--prettylights-syntax-sublimelinter-gutter-mark",
        "--prettylights-syntax-variable"
    ]

    @Test("the bridge never invents a property name",
          arguments: PrettyLights.bridges.map { $0.property })
    func noBridgeInventsAName(property: String)
    {
        #expect(
            PrettyLightsTests.published.contains(property),
            "\(property) is declared nowhere in Primer")
    }

    @Test("both spellings of a role are bridged together")
    func everyRoleCarriesBothFamilies()
    {
        let canonical = PrettyLights.bridges
            .filter { $0.property.hasPrefix("--prettylights-") }
        let legacy = PrettyLights.bridges
            .filter { $0.property.hasPrefix("--color-prettylights-") }
        #expect(canonical.count == legacy.count)
        #expect(canonical.count == 16)
    }
}
