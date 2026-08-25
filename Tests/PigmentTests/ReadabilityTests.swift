import Testing

@testable import Pigment

@Suite("Perceptual readability")
struct ReadabilityTests
{
    private static let white = SRGB(hexNotation: "#ffffff")!
    private static let black = SRGB(hexNotation: "#000000")!
    private static let middle = SRGB(hexNotation: "#888888")!

    @Test(
        "the published reference pairs are reproduced",
        arguments: [
            ("#000000", "#ffffff", 106.04),
            ("#ffffff", "#000000", -107.88),
            ("#888888", "#ffffff", 63.06),
            ("#ffffff", "#888888", -68.54)
        ])
    func referencePairs(ink: String, ground: String, expected: Double)
    {
        let found = Readability.between(
            SRGB(hexNotation: ink)!,
            SRGB(hexNotation: ground)!)
        #expect(abs(found.value - expected) < 0.01, "\(ink) on \(ground)")
    }

    @Test("polarity is signed, dark ink on light ground positive")
    func polarityIsSigned()
    {
        #expect(Readability.between(Self.black, Self.white).value > 0)
        #expect(Readability.between(Self.white, Self.black).value < 0)
    }

    @Test("a colour against itself reads as nothing")
    func selfIsBlank()
    {
        for hex in ["#ffffff", "#000000", "#888888", "#1e6f3a"]
        {
            let colour = SRGB(hexNotation: hex)!
            #expect(Readability.between(colour, colour).value == 0, "\(hex)")
        }
    }

    @Test("magnitude discards polarity")
    func magnitudeDiscardsPolarity()
    {
        let reversed = Readability.between(Self.white, Self.black)
        #expect(reversed.value < 0)
        #expect(reversed.magnitude > 0)
        #expect(reversed.magnitude == -reversed.value)
    }

    @Test("readability rises as the ink parts from the ground")
    func risesWithSeparation()
    {
        var previous = 0.0
        for step in stride(from: 0.1, through: 0.9, by: 0.1)
        {
            let ink = SRGB(red: 1 - step, green: 1 - step, blue: 1 - step)
            let found = Readability.between(ink, Self.white).magnitude
            #expect(found >= previous, "step \(step)")
            previous = found
        }
    }
}
