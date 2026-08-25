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

    @Test("sealing raises every declaration, however deeply nested")
    func sealingReachesEverything()
    {
        let sealed = sheet.userOrigin.text
        let declarations = sealed
            .split(separator: "\n")
            .filter { $0.contains(":") && $0.hasSuffix(";") }
        #expect(!declarations.isEmpty)
        for declaration in declarations
        {
            #expect(
                declaration.contains("!important"),
                "unsealed: \(declaration)")
        }
    }

    @Test("an unsealed sheet claims no importance anywhere")
    func anUnsealedSheetIsQuiet()
    {
        #expect(!sheet.text.contains("!important"))
    }
}
