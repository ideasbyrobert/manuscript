import Testing

@testable import UserSheet

@Suite("Stacks that reach the faces they name")
struct FontStackTests
{
    @Test("an Apple face is reachable only by its keyword")
    func stacksLeadWithTheKeyword()
    {
        #expect(FontStack.mono.hasPrefix("ui-monospace,"))
    }

    @Test("a stack always ends somewhere")
    func stacksEndInAGenericFamily()
    {
        #expect(FontStack.mono.hasSuffix(", monospace"))
    }
}
