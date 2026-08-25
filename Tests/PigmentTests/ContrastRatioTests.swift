import Testing

@testable import Pigment

@Suite("Measuring contrast")
struct ContrastRatioTests
{
    private func colour(_ notation: String) throws -> SRGB
    {
        try #require(SRGB(hexNotation: notation))
    }

    @Test("black on white is the widest contrast there is")
    func extremes() throws
    {
        let widest = ContrastRatio.between(
            try colour("#000000"),
            try colour("#ffffff"))
        #expect(abs(widest.value - 21) < 1e-9)
    }

    @Test("a colour against itself has no contrast")
    func identity() throws
    {
        let none = ContrastRatio.between(
            try colour("#ff383c"),
            try colour("#ff383c"))
        #expect(abs(none.value - 1) < 1e-9)
    }

    @Test("contrast does not care which argument is the ink")
    func symmetric() throws
    {
        let ink = try colour("#1e1612")
        let ground = try colour("#fff7f2")
        let forward = ContrastRatio.between(ink, ground)
        let backward = ContrastRatio.between(ground, ink)
        #expect(forward == backward)
    }

    @Test("darkening an ink on a light ground raises contrast")
    func monotonic() throws
    {
        let ground = try colour("#ffffff")
        var previous = ContrastRatio(0)
        for step in stride(from: 0.9, through: 0.1, by: -0.1)
        {
            let ink = OKLCh(
                lightness: Lightness(step),
                chroma: Chroma(0.05),
                hue: Hue(degrees: 25)).srgb
            let measured = ContrastRatio.between(ink, ground)
            #expect(measured > previous)
            previous = measured
        }
    }

    @Test("a float literal reads as a ratio")
    func literal()
    {
        let target: ContrastRatio = 4.5
        #expect(target.value == 4.5)
    }
}
