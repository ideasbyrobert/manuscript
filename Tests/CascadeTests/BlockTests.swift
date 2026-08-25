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
        let block = Block.when(.dark, [.rule(painted), .rule(painted)])
        let count = block.important.text
            .split(separator: "\n")
            .filter { $0.hasSuffix("!important;") }
            .count
        #expect(count == 2, "raised \(count) of 2")
    }

    @Test("two rules under one condition keep a blank line between them")
    func siblingsStayApartWithoutStrayIndent()
    {
        let block = Block.when(.dark, [.rule(painted), .rule(painted)])
        #expect(block.text == """
        @media (prefers-color-scheme: dark)
        {
            :root
            {
                color: #eee;
            }

            :root
            {
                color: #eee;
            }
        }
        """)
    }

    @Test("a condition inside a condition indents twice")
    func nestingIndentsAgain()
    {
        let block = Block.when(.dark, [.when(.light, [.rule(painted)])])
        #expect(block.text == """
        @media (prefers-color-scheme: dark)
        {
            @media (prefers-color-scheme: light)
            {
                :root
                {
                    color: #eee;
                }
            }
        }
        """)
    }
}
