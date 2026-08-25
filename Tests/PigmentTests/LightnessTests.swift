import Testing

@testable import Pigment

@Suite("Lightness is confined to the unit interval")
struct LightnessTests
{
    @Test("values beyond the ends are clamped")
    func clamps()
    {
        #expect(Lightness(1.4).value == 1)
        #expect(Lightness(-0.3).value == 0)
        #expect(Lightness(0.5).value == 0.5)
    }

    @Test("a nonsense value falls back to the darkest end")
    func handlesNaN()
    {
        #expect(Lightness(.nan).value == 0)
    }

    @Test("adjusting past an end stops at the end")
    func adjustmentIsBounded()
    {
        #expect(Lightness.lightest.adjusted(by: 0.5) == .lightest)
        #expect(Lightness.darkest.adjusted(by: -0.5) == .darkest)
    }

    @Test("the midpoint sits between its arguments")
    func midpoint()
    {
        let middle = Lightness.midpoint(Lightness(0.2), Lightness(0.8))
        #expect(middle.value == 0.5)
        #expect(Lightness.midpoint(.darkest, .lightest).value == 0.5)
    }

    @Test("distance is symmetric")
    func distanceIsSymmetric()
    {
        let one = Lightness(0.2)
        let other = Lightness(0.9)
        #expect(one.distance(to: other) == other.distance(to: one))
    }
}
