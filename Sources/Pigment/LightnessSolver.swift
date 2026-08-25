package struct LightnessSolver: Sendable
{
    private static let refinements = 40

    private let ground: SRGB
    private let groundLightness: Lightness
    private let inkGrowsLighter: Bool

    package init(ground: SRGB)
    {
        self.ground = ground
        groundLightness = OKLCh(ground).lightness
        let luminance = Luminance(ground).value
        let lightening = 1.05 / (luminance + 0.05)
        let darkening = (luminance + 0.05) / 0.05
        inkGrowsLighter = lightening >= darkening
    }

    package func lightnessReaching(
        _ target: ContrastRatio,
        hue: Hue,
        chroma: Chroma) -> Lightness
    {
        let extreme = inkGrowsLighter
            ? Lightness.lightest
            : Lightness.darkest
        precondition(
            contrast(at: extreme, hue: hue, chroma: chroma) >= target,
            "no lightness on this ground reaches \(target)")

        var failing = groundLightness
        var succeeding = extreme
        for _ in 0 ..< Self.refinements
        {
            let candidate = Lightness.midpoint(failing, succeeding)
            if contrast(at: candidate, hue: hue, chroma: chroma) >= target
            {
                succeeding = candidate
            }
            else
            {
                failing = candidate
            }
        }
        return Lightness.midpoint(failing, succeeding)
    }

    private func contrast(
        at lightness: Lightness,
        hue: Hue,
        chroma: Chroma) -> ContrastRatio
    {
        let ink = OKLCh(lightness: lightness, chroma: chroma, hue: hue).srgb
        return ContrastRatio.between(ink, ground)
    }
}
