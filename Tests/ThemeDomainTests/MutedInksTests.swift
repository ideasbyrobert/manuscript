import Testing

@testable import AppleColors
@testable import ThemeDomain

@Suite("Brown alone is lifted")
struct MutedInksTests
{
    @Test("brown is boosted by about a third; every other ink is left")
    func brownAlone()
    {
        #expect(MutedInks.boost(for: .brown) == 1.32)
        for colour in SystemColour.allCases where colour != .brown
        {
            #expect(MutedInks.boost(for: colour) == 1.0, "\(colour)")
        }
    }
}
