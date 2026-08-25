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

    @Test("author origin lifts every selector and marks every declaration")
    func authorOriginLiftsAndMarks()
    {
        let sheet = StyleSheet(
            [.rule(Rule([".k"], [Declaration("color", "red")]))])
            .authorOrigin(floor: ["a", "b"])
        #expect(sheet.text.contains(".k:not(#a):not(#b)"))
        #expect(sheet.text.contains("color: red !important;"))
    }

    @Test("the media block survives lifting")
    func mediaSurvivesLifting()
    {
        let sheet = StyleSheet(
            [.when(.dark, [.rule(Rule([".k"], [Declaration("x", "y")]))])])
            .authorOrigin(floor: ["a"])
        #expect(sheet.text.contains("@media"))
        #expect(sheet.text.contains(".k:not(#a)"))
        #expect(sheet.text.contains("y !important;"))
    }

}
