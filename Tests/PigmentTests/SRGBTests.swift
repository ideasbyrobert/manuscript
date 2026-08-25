import Testing

@testable import Pigment

@Suite("Reading and writing sRGB")
struct SRGBTests
{
    @Test(
        "hex notation survives a round trip",
        arguments:
        [
            "#000000", "#ffffff", "#ff383c", "#0088ff", "#8e8e93", "#1e1612"
        ])
    func roundTrips(notation: String) throws
    {
        let colour = try #require(SRGB(hexNotation: notation))
        #expect(colour.hexNotation == notation)
    }

    @Test("a missing hash is tolerated")
    func toleratesMissingHash() throws
    {
        let colour = try #require(SRGB(hexNotation: "ff383c"))
        #expect(colour.hexNotation == "#ff383c")
    }

    @Test(
        "malformed notation is rejected",
        arguments: ["", "#fff", "#gggggg", "#1234567", "zzzzzz"])
    func rejectsMalformed(notation: String)
    {
        #expect(SRGB(hexNotation: notation) == nil)
    }

    @Test("components outside the cube are clipped, not wrapped")
    func clips()
    {
        let beyond = SRGB(red: 1.4, green: -0.3, blue: 0.5)
        #expect(beyond.clipped.red == 1)
        #expect(beyond.clipped.green == 0)
        #expect(beyond.clipped.blue == 0.5)
        #expect(beyond.hexNotation == "#ff0080")
    }

    @Test("gamut membership is exact, and tolerant when asked")
    func gamutMembership()
    {
        let edge = SRGB(red: 1.00005, green: 0, blue: 0)
        #expect(!edge.isWithinGamut)
        #expect(edge.isWithinGamut(tolerating: 1e-4))
        #expect(!edge.isWithinGamut(tolerating: 1e-6))
    }
}
