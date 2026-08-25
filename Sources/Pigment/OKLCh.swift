import Foundation

package struct OKLCh: Hashable, Sendable
{
    package let lightness: Lightness
    package let chroma: Chroma
    package let hue: Hue

    package init(lightness: Lightness, chroma: Chroma, hue: Hue)
    {
        self.lightness = lightness
        self.chroma = chroma
        self.hue = hue
    }

    package init(_ colour: SRGB)
    {
        let lab = OKLab(colour)
        self.init(
            lightness: Lightness(lab.lightness),
            chroma: Chroma((lab.a * lab.a + lab.b * lab.b).squareRoot()),
            hue: Hue(degrees: atan2(lab.b, lab.a) * 180 / .pi))
    }

    package init?(hexNotation: String)
    {
        guard let colour = SRGB(hexNotation: hexNotation) else
        {
            return nil
        }
        self.init(colour)
    }

    var unclamped: SRGB
    {
        OKLab(
            lightness: lightness.value,
            a: chroma.value * cos(hue.radians),
            b: chroma.value * sin(hue.radians)).srgb
    }

    package var srgb: SRGB
    {
        Gamut.sRGB.clamp(self).unclamped.clipped
    }

    var hexNotation: String
    {
        srgb.hexNotation
    }

    package func withLightness(_ replacement: Lightness) -> OKLCh
    {
        OKLCh(lightness: replacement, chroma: chroma, hue: hue)
    }

    func withChroma(_ replacement: Chroma) -> OKLCh
    {
        OKLCh(lightness: lightness, chroma: replacement, hue: hue)
    }
}
