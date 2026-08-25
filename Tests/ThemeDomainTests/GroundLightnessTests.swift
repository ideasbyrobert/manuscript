import Testing

@testable import AppleColors
@testable import Pigment
@testable import ThemeDomain

@Suite("Where the ground sits")
struct GroundLightnessTests
{
    @Test("the light ground is near paper, the dark near ink")
    func groundsAreAtTheEnds()
    {
        #expect(GroundLightness.of(.light).value > 0.9)
        #expect(GroundLightness.of(.dark).value < 0.3)
    }

    @Test("a dark ground carries more tint before it reads as coloured")
    func darkToleratesMoreTint()
    {
        #expect(
            GroundLightness.tintCeiling(for: .dark)
                > GroundLightness.tintCeiling(for: .light))
    }

    @Test("only brown is boosted, and only upward")
    func onlyBrownIsBoosted()
    {
        for colour in SystemColour.allCases
        {
            let boost = MutedInks.boost(for: colour)
            #expect(boost >= 1.0)
            #expect((boost > 1.0) == (colour == .brown))
        }
    }
}
