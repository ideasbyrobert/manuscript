package struct LightnessSolver: Sendable
{
    private static let refinements = 40

    private let ground: SRGB
    private let groundLightness: Lightness
    private let groundIsDark: Bool

    package init(ground: SRGB)
    {
        self.ground = ground
        groundLightness = OKLCh(ground).lightness
        groundIsDark = Luminance(ground).value < 0.2
    }

    package func lightnessReaching(
        _ target: ContrastRatio,
        hue: Hue,
        chroma: Chroma) -> Lightness
    {
        var nearer = groundIsDark ? groundLightness : Lightness.darkest
        var further = groundIsDark ? Lightness.lightest : groundLightness

        for _ in 0 ..< Self.refinements
        {
            let candidate = Lightness.midpoint(nearer, further)
            let reached = contrast(at: candidate, hue: hue, chroma: chroma)
                >= target
            if groundIsDark == reached
            {
                further = candidate
            }
            else
            {
                nearer = candidate
            }
        }
        return Lightness.midpoint(nearer, further)
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
