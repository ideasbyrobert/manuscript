import Testing

@testable import Pigment

@Suite("Hue lives on a circle")
struct HueTests
{
    @Test("degrees wrap onto a single turn")
    func wraps()
    {
        #expect(Hue(degrees: 380).degrees == 20)
        #expect(Hue(degrees: -20).degrees == 340)
        #expect(Hue(degrees: 720).degrees == 0)
        #expect(Hue(degrees: -400).degrees == 320)
    }

    @Test("separation takes the shorter way round")
    func separation()
    {
        #expect(Hue(degrees: 10).separation(from: Hue(degrees: 350)) == 20)
        #expect(Hue(degrees: 350).separation(from: Hue(degrees: 10)) == 20)
        #expect(Hue(degrees: 0).separation(from: Hue(degrees: 180)) == 180)
    }

    @Test("separation never exceeds half a turn")
    func separationIsBounded()
    {
        for one in stride(from: 0.0, to: 360.0, by: 17.0)
        {
            for other in stride(from: 0.0, to: 360.0, by: 23.0)
            {
                let apart = Hue(degrees: one)
                    .separation(from: Hue(degrees: other))
                #expect(apart >= 0)
                #expect(apart <= 180)
            }
        }
    }
}
