import Testing

@testable import AppleColors

@Suite("Light and dark")
struct AppearanceTests
{
    @Test("there are exactly two appearances")
    func twoAppearances()
    {
        #expect(Appearance.allCases.count == 2)
    }

    @Test("each appearance is the opposite of the other")
    func oppositesPair()
    {
        #expect(Appearance.light.opposite == .dark)
        #expect(Appearance.dark.opposite == .light)
    }

    @Test("taking the opposite twice returns the original")
    func oppositeIsAnInvolution()
    {
        for appearance in Appearance.allCases
        {
            #expect(appearance.opposite.opposite == appearance)
        }
    }

    @Test("the title is the name with a capital")
    func titles()
    {
        #expect(Appearance.light.title == "Light")
        #expect(Appearance.dark.title == "Dark")
    }
}
