import Testing

@testable import AppleColors

@Suite("The named system colours")
struct SystemColourTests
{
    @Test("the roll call matches what Apple publishes")
    func rollCall()
    {
        #expect(SystemColour.allCases.count == 13)
        let names = Set(SystemColour.allCases.map(\.rawValue))
        #expect(names.contains("red"))
        #expect(names.contains("mint"))
        #expect(names.contains("brown"))
        #expect(names.contains("gray"))
    }

    @Test("no name repeats")
    func namesAreUnique()
    {
        let names = SystemColour.allCases.map(\.rawValue)
        #expect(Set(names).count == names.count)
    }

    @Test("every colour can be named and read back")
    func namesRoundTrip()
    {
        for colour in SystemColour.allCases
        {
            #expect(SystemColour(rawValue: colour.rawValue) == colour)
        }
    }
}
