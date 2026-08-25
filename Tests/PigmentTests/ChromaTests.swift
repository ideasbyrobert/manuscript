import Testing

@testable import Pigment

@Suite("Chroma is never negative")
struct ChromaTests
{
    @Test("a negative request becomes none")
    func neverNegative()
    {
        #expect(Chroma(-1).value == 0)
        #expect(Chroma(.nan).value == 0)
        #expect(Chroma.none.value == 0)
    }

    @Test("scaling and capping compose")
    func scalesAndCaps()
    {
        let base = Chroma(0.2)
        #expect(base.scaled(by: 0.5).value == 0.1)
        #expect(base.capped(at: 0.05).value == 0.05)
        #expect(base.capped(at: 0.5).value == 0.2)
    }

    @Test("scaling by a negative factor yields none")
    func negativeScaleIsNone()
    {
        #expect(Chroma(0.2).scaled(by: -2).value == 0)
    }
}
