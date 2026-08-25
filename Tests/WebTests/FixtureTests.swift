import Testing

@testable import Web

@Suite("The page the harness reads")
struct FixtureTests
{
    @Test("it carries a grounded block and an inline-important block")
    func carriesBothShapes()
    {
        #expect(Fixture.page.contains("id=\"grounded\""))
        #expect(Fixture.page.contains("id=\"inline\""))
        #expect(Fixture.page.contains("class=\"highlight\""))
        #expect(Fixture.page.contains("rgb(1, 2, 3) !important"))
    }

    @Test("it is one well-formed document")
    func oneDocument()
    {
        #expect(Fixture.page.hasPrefix("<!DOCTYPE html>"))
        #expect(Fixture.page.contains("</html>"))
    }
}
