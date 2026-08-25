import Foundation

public struct OKLCh: Hashable, Sendable
{
    public let lightness: Lightness
    public let chroma: Chroma
    public let hue: Hue

    public init(lightness: Lightness, chroma: Chroma, hue: Hue)
    {
        self.lightness = lightness
        self.chroma = chroma
        self.hue = hue
    }

    public init(_ colour: SRGB)
    {
        let lab = OKLab(colour)
        self.init(
            lightness: Lightness(lab.lightness),
            chroma: Chroma((lab.a * lab.a + lab.b * lab.b).squareRoot()),
            hue: Hue(degrees: atan2(lab.b, lab.a) * 180 / .pi))
    }

    public init?(hexNotation: String)
    {
        guard let colour = SRGB(hexNotation: hexNotation) else
        {
            return nil
        }
        self.init(colour)
    }

    public var unclamped: SRGB
    {
        OKLab(
            lightness: lightness.value,
            a: chroma.value * cos(hue.radians),
            b: chroma.value * sin(hue.radians)).srgb
    }

    public var srgb: SRGB
    {
        Gamut.sRGB.clamp(self).unclamped.clipped
    }

    public var hexNotation: String
    {
        srgb.hexNotation
    }

    public func withLightness(_ replacement: Lightness) -> OKLCh
    {
        OKLCh(lightness: replacement, chroma: chroma, hue: hue)
    }

    public func withChroma(_ replacement: Chroma) -> OKLCh
    {
        OKLCh(lightness: lightness, chroma: replacement, hue: hue)
    }
}
