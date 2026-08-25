import Testing

@testable import Cascade
@testable import ThemeDomain
@testable import UserSheet

@Suite("A rule that declares a theme's roles as tokens")
struct TokensTests
{
    private let theme = Theme.catalogue()[0]

    @Test("one declaration per role, named and valued from the theme")
    func oneDeclarationPerRole() throws
    {
        let rule = Tokens.rule(
            for: theme,
            on: [":root"],
            roles: [.background, .keyword])
        #expect(rule.selectors == [":root"])
        try #require(rule.declarations.count == 2)
        let first = rule.declarations[0]
        let second = rule.declarations[1]
        #expect(first.property == "--manuscript-background")
        #expect(first.value == theme.palette.notation(.background))
        #expect(second.property == "--manuscript-keyword")
        #expect(second.value == theme.palette.notation(.keyword))
        #expect(!first.isImportant)
    }

    @Test("no roles, no declarations, and the rule renders to nothing")
    func noRolesNoText()
    {
        let rule = Tokens.rule(for: theme, on: [":root"], roles: [])
        #expect(rule.declarations.isEmpty)
        #expect(rule.text == "")
    }
}
