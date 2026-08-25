import Testing

@testable import Pigment

@Suite("What sRGB can hold")
struct GamutTests
{
    private let gamut = Gamut.sRGB

    @Test("a primary is inside; the same hue at absurd chroma is not")
    func edges()
    {
        let red = OKLCh(SRGB(red: 1, green: 0, blue: 0))
        #expect(gamut.contains(red))
        #expect(!gamut.contains(red.withChroma(Chroma(0.5))))
    }

    @Test("clamping keeps lightness and hue and moves only chroma inward")
    func clampMovesChromaOnly()
    {
        let wild = OKLCh(
            lightness: Lightness(0.6),
            chroma: Chroma(0.4),
            hue: Hue(degrees: 30))
        let held = gamut.clamp(wild)
        #expect(gamut.contains(held))
        #expect(held.lightness == wild.lightness)
        #expect(held.hue == wild.hue)
        #expect(held.chroma < wild.chroma)
    }

    @Test("a colour already inside comes back untouched")
    func insideIsIdentity()
    {
        let mild = OKLCh(
            lightness: Lightness(0.6),
            chroma: Chroma(0.05),
            hue: Hue(degrees: 30))
        #expect(gamut.clamp(mild) == mild)
    }

    @Test("the widest chroma is the edge: a little more falls out")
    func widestIsTheEdge()
    {
        let lightness = Lightness(0.7)
        let hue = Hue(degrees: 140)
        let widest = gamut.widestChroma(at: lightness, hue: hue)
        let edge = OKLCh(lightness: lightness, chroma: widest, hue: hue)
        #expect(gamut.contains(edge))
        #expect(!gamut.contains(edge.withChroma(widest.scaled(by: 1.05))))
        #expect(widest.value > 0.1)
    }
}
