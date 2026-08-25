import Testing

@testable import Cascade

@Suite("A sheet sealed at user origin")
struct StyleSheetTests
{
    private var ground: Rule
    {
        Rule(["html"], [Declaration("background-color", "#fff")])
    }

    private var sheet: StyleSheet
    {
        StyleSheet([
            .rule(ground),
            .when(.dark, [.rule(ground)])
        ])
    }

    @Test("blocks are separated by a blank line")
    func blocksAreSeparated()
    {
        #expect(sheet.text.contains("}\n\n@media"))
    }

    @Test("a block that writes nothing leaves no blank gap")
    func silentBlocksLeaveNoGap()
    {
        let padded = StyleSheet([
            .rule(Rule([], [])),
            .rule(ground)
        ])
        #expect(padded.text == ground.text)
    }

    @Test("sealing raises every declaration and changes nothing else")
    func sealingReachesEverything()
    {
        let expected = sheet.text
            .split(separator: ";", omittingEmptySubsequences: false)
            .joined(separator: " !important;")
        #expect(sheet.userOrigin.text == expected)
        #expect(sheet.text.contains(";"))
    }

    @Test("an unsealed sheet claims no importance anywhere")
    func anUnsealedSheetIsQuiet()
    {
        #expect(!sheet.text.contains("!important"))
    }
}
