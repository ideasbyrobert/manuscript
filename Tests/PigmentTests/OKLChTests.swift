import Testing

@testable import Pigment

@Suite("Cylindrical perceptual coordinates")
struct OKLChTests
{
    @Test(
        "a colour survives the trip through OKLCh",
        arguments:
        [
            "#ff383c", "#34c759", "#0088ff", "#cb30e0", "#1e1612", "#ffffff"
        ])
    func roundTrips(notation: String) throws
    {
        let colour = try #require(OKLCh(hexNotation: notation))
        #expect(colour.hexNotation == notation)
    }

    @Test("malformed notation is rejected")
    func rejectsMalformed()
    {
        #expect(OKLCh(hexNotation: "#fff") == nil)
    }

    @Test("replacing one coordinate leaves the others alone")
    func replacementIsSurgical() throws
    {
        let colour = try #require(OKLCh(hexNotation: "#ff383c"))
        let lighter = colour.withLightness(Lightness(0.9))
        #expect(lighter.hue == colour.hue)
        #expect(lighter.chroma == colour.chroma)
        #expect(lighter.lightness.value == 0.9)
    }

    @Test("an unreachable chroma is clamped, and its hue is kept")
    func clampsToGamut()
    {
        let beyond = OKLCh(
            lightness: Lightness(0.5),
            chroma: Chroma(0.4),
            hue: Hue(degrees: 25))
        #expect(!Gamut.sRGB.contains(beyond))
        let clamped = Gamut.sRGB.clamp(beyond)
        #expect(Gamut.sRGB.contains(clamped))
        #expect(clamped.hue == beyond.hue)
        #expect(clamped.lightness == beyond.lightness)
        #expect(clamped.chroma < beyond.chroma)
    }

    @Test("a reachable colour is left untouched")
    func leavesReachableAlone()
    {
        let inside = OKLCh(
            lightness: Lightness(0.5),
            chroma: Chroma(0.02),
            hue: Hue(degrees: 25))
        #expect(Gamut.sRGB.clamp(inside).chroma == inside.chroma)
    }

    @Test("every emitted colour is inside the cube")
    func emittedColoursAreLegal()
    {
        for degrees in stride(from: 0.0, to: 360.0, by: 11.0)
        {
            for value in stride(from: 0.05, to: 1.0, by: 0.13)
            {
                let colour = OKLCh(
                    lightness: Lightness(value),
                    chroma: Chroma(0.35),
                    hue: Hue(degrees: degrees))
                #expect(colour.srgb.isWithinGamut)
            }
        }
    }
}
