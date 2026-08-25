import Testing

@testable import Cascade

@Suite("Selectors and the block they open")
struct RuleTests
{
    @Test("a rule opens its brace on a line of its own")
    func braceSitsOnItsOwnLine()
    {
        let rule = Rule([":root"], [Declaration("color", "red")])
        #expect(rule.text == """
        :root
        {
            color: red;
        }
        """)
    }

    @Test("several selectors are listed one to a line")
    func selectorsAreListed()
    {
        let rule = Rule(
            ["html", "body"],
            [Declaration("margin", "0")])
        #expect(rule.text.hasPrefix("html,\nbody\n{"))
    }

    @Test("a rule with no declarations is not written at all")
    func emptyBodyIsSilent()
    {
        #expect(Rule([":root"], []).text.isEmpty)
    }

    @Test("a rule with no selector is not written at all")
    func emptyHeadIsSilent()
    {
        #expect(Rule([], [Declaration("color", "red")]).text.isEmpty)
    }

    @Test("raising a rule raises every declaration in it")
    func raisingReachesEveryDeclaration()
    {
        let rule = Rule(
            [":root"],
            [
                Declaration("color", "red"),
                Declaration("background-color", "white")
            ])
        for declaration in rule.important.declarations
        {
            #expect(declaration.isImportant)
        }
    }
}
