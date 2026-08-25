import Testing

@testable import Specimen
@testable import ThemeDomain

@Suite("Braces mark a run of text with a role")
struct SpecimenMarkupTests
{
    @Test("plain text around a marked run is kept, in order")
    func plainAroundMarked()
    {
        let found = SpecimenMarkup.tokens(in: "let {member|x} = 1")
        #expect(found == [
            SpecimenToken("let ", role: nil),
            SpecimenToken("x", role: .member),
            SpecimenToken(" = 1", role: nil)
        ])
    }

    @Test("two marked runs may touch")
    func adjacentRuns()
    {
        let found = SpecimenMarkup.tokens(in: "{keyword|if}{operator|!}")
        #expect(found.map(\.role) == [.keyword, .operator])
        #expect(found.map(\.text) == ["if", "!"])
    }

    @Test("a brace without a bar is only a brace")
    func braceWithoutBar()
    {
        let found = SpecimenMarkup.tokens(in: "{ x }")
        #expect(found == [SpecimenToken("{ x }", role: nil)])
    }

    @Test("an empty line yields nothing")
    func empty()
    {
        #expect(SpecimenMarkup.tokens(in: "").isEmpty)
    }
}
