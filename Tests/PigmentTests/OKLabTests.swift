import Testing

@testable import Pigment

@Suite("Perceptual coordinates")
struct OKLabTests
{
    @Test(
        "a colour survives the trip through OKLab",
        arguments:
        [
            "#ff383c", "#34c759", "#0088ff", "#cb30e0", "#ac7f5e",
            "#fff7f2", "#000000", "#ffffff"
        ])
    func roundTrips(notation: String) throws
    {
        let colour = try #require(SRGB(hexNotation: notation))
        #expect(OKLab(colour).srgb.hexNotation == notation)
    }

    @Test("grey has no chroma in either direction")
    func greyIsNeutral() throws
    {
        let grey = try #require(SRGB(hexNotation: "#808080"))
        let lab = OKLab(grey)
        #expect(abs(lab.a) < 1e-6)
        #expect(abs(lab.b) < 1e-6)
    }

    @Test("black and white sit at the ends of lightness")
    func lightnessEnds() throws
    {
        let black = OKLab(try #require(SRGB(hexNotation: "#000000")))
        let white = OKLab(try #require(SRGB(hexNotation: "#ffffff")))
        #expect(abs(black.lightness) < 1e-9)
        #expect(abs(white.lightness - 1) < 1e-6)
    }

    @Test("the cube root keeps the sign of its argument")
    func cubeRootIsOdd()
    {
        #expect(OKLab.cubeRoot(8) == 2)
        #expect(OKLab.cubeRoot(-8) == -2)
        #expect(OKLab.cubeRoot(0) == 0)
    }

    @Test("blending at nought and one returns the endpoints")
    func blendEndpoints() throws
    {
        let one = OKLab(try #require(SRGB(hexNotation: "#ff383c")))
        let other = OKLab(try #require(SRGB(hexNotation: "#0088ff")))
        let start = one.blended(towards: other, by: 0)
        let finish = one.blended(towards: other, by: 1)
        #expect(start.srgb.hexNotation == "#ff383c")
        #expect(finish.srgb.hexNotation == "#0088ff")
    }

    @Test("a half blend lies between its endpoints in lightness")
    func blendIsMonotonic() throws
    {
        let dark = OKLab(try #require(SRGB(hexNotation: "#1e1612")))
        let light = OKLab(try #require(SRGB(hexNotation: "#fff7f2")))
        let middle = dark.blended(towards: light, by: 0.5)
        #expect(middle.lightness > dark.lightness)
        #expect(middle.lightness < light.lightness)
    }
}
