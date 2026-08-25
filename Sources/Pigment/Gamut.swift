package struct Gamut: Sendable
{
    package static let sRGB = Gamut()

    private static let refinements = 28
    private static let slack = 1e-4

    func contains(_ colour: OKLCh) -> Bool
    {
        colour.unclamped.isWithinGamut(tolerating: Self.slack)
    }

    package func widestChroma(at lightness: Lightness, hue: Hue) -> Chroma
    {
        clamp(OKLCh(
            lightness: lightness,
            chroma: Chroma(0.5),
            hue: hue)).chroma
    }

    func clamp(_ colour: OKLCh) -> OKLCh
    {
        guard !contains(colour) else
        {
            return colour
        }
        var reachable = Chroma.none
        var unreachable = colour.chroma
        for _ in 0 ..< Self.refinements
        {
            let candidate = Chroma((reachable.value + unreachable.value) / 2)
            if contains(colour.withChroma(candidate))
            {
                reachable = candidate
            }
            else
            {
                unreachable = candidate
            }
        }
        return colour.withChroma(reachable)
    }
}
