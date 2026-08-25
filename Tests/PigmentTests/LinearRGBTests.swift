import Testing

@testable import Pigment

@Suite("Undoing the transfer function")
struct LinearRGBTests
{
    @Test(
        "encoding and expanding are inverses",
        arguments: ["#000000", "#ffffff", "#808080", "#ff383c", "#0088ff"])
    func inverses(notation: String) throws
    {
        let colour = try #require(SRGB(hexNotation: notation))
        #expect(LinearRGB(colour).encoded.hexNotation == notation)
    }

    @Test("the endpoints are fixed to within floating point")
    func endpoints()
    {
        #expect(LinearRGB.expanded(0) == 0)
        #expect(LinearRGB.compressed(0) == 0)
        #expect(abs(LinearRGB.expanded(1) - 1) < 1e-12)
        #expect(abs(LinearRGB.compressed(1) - 1) < 1e-12)
    }

    @Test("the linear segment governs the darkest values")
    func linearNearBlack()
    {
        #expect(abs(LinearRGB.expanded(0.04) - 0.04 / 12.92) < 1e-12)
    }

    @Test("mid grey is far darker once linear")
    func midGreyIsDarker()
    {
        let linear = LinearRGB.expanded(0.5)
        #expect(linear < 0.25)
        #expect(linear > 0.21)
    }
}
