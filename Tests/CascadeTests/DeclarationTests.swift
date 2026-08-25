import Testing

@testable import Cascade

@Suite("A single property, said once")
struct DeclarationTests
{
    @Test("a plain declaration ends in a semicolon and nothing else")
    func plainDeclaration()
    {
        let colour = Declaration("color", "#1c1b19")
        #expect(colour.text == "color: #1c1b19;")
    }

    @Test("importance is spelled where the cascade looks for it")
    func importantDeclaration()
    {
        let colour = Declaration("color", "#1c1b19").important
        #expect(colour.text == "color: #1c1b19 !important;")
    }

    @Test("raising a declaration keeps what it says")
    func raisingPreservesMeaning()
    {
        let plain = Declaration("background-color", "#fdfcfa")
        let raised = plain.important
        #expect(raised.property == plain.property)
        #expect(raised.value == plain.value)
    }

    @Test("raising twice says important once")
    func raisingIsIdempotent()
    {
        let once = Declaration("color", "red").important
        #expect(once.important.text == once.text)
    }

    @Test("a custom property is an ordinary declaration")
    func customPropertiesNeedNoSpecialCase()
    {
        let token = Declaration("--manuscript-keyword", "#9700a8")
        #expect(token.important.text
            == "--manuscript-keyword: #9700a8 !important;")
    }
}
