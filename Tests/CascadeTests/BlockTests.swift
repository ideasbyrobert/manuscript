import Testing

@testable import Cascade

@Suite("Rules, and the conditions that hold them")
struct BlockTests
{
    private var painted: Rule
    {
        Rule([":root"], [Declaration("color", "#eee")])
    }

    @Test("a bare rule reads exactly as the rule does")
    func aBareRuleIsUnchanged()
    {
        #expect(Block.rule(painted).text == painted.text)
    }

    @Test("a condition indents everything it encloses")
    func conditionIndentsItsContents()
    {
        let block = Block.when(.dark, [.rule(painted)])
        #expect(block.text == """
        @media (prefers-color-scheme: dark)
        {
            :root
            {
                color: #eee;
            }
        }
        """)
    }

    @Test("a condition enclosing nothing is not written at all")
    func emptyConditionIsSilent()
    {
        #expect(Block.when(.dark, []).text.isEmpty)
        #expect(Block.when(.dark, [.rule(Rule([], []))]).text.isEmpty)
    }

    @Test("raising reaches rules nested inside a condition")
    func raisingDescendsThroughConditions()
    {
        let block = Block.when(.dark, [.rule(painted)])
        #expect(block.important.text.contains("!important"))
    }
}
