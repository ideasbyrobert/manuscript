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

    @Test("no stack names a face Safari has been shown to ignore")
    func noStackCarriesAnInertName()
    {
        let families = FontStack.mono
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
        for family in families
        {
            #expect(!family.contains("\""), "\(family) is quoted for nothing")
            #expect(
                !family.hasPrefix("SF"),
                "\(family) names an Apple face by a name Safari refuses")
        }
    }
}
