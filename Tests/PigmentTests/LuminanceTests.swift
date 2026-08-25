import Testing

@testable import Pigment

@Suite("Luminance weighs the channels as the eye does")
struct LuminanceTests
{
    @Test("black is nothing and white is everything")
    func extremes()
    {
        #expect(Luminance(SRGB(red: 0, green: 0, blue: 0)).value == 0)
        let white = Luminance(SRGB(red: 1, green: 1, blue: 1)).value
        #expect(abs(white - 1) < 1e-12)
    }

    @Test("green carries most of it, blue least")
    func channelWeights()
    {
        let red = Luminance(SRGB(red: 1, green: 0, blue: 0)).value
        let green = Luminance(SRGB(red: 0, green: 1, blue: 0)).value
        let blue = Luminance(SRGB(red: 0, green: 0, blue: 1)).value
        #expect(abs(red - 0.2126) < 1e-12)
        #expect(abs(green - 0.7152) < 1e-12)
        #expect(abs(blue - 0.0722) < 1e-12)
        #expect(abs(red + green + blue - 1) < 1e-12)
    }

    @Test("it is linear light, not the encoded value")
    func linearNotEncoded()
    {
        let half = SRGB(red: 0.5, green: 0.5, blue: 0.5)
        #expect(abs(Luminance(half).value - 0.2140) < 0.0005)
    }
}
