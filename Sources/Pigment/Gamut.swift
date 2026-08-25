public struct Gamut: Sendable
{
    public static let sRGB = Gamut()

    private static let refinements = 28
    private static let slack = 1e-4

    public func contains(_ colour: OKLCh) -> Bool
    {
        colour.unclamped.isWithinGamut(tolerating: Self.slack)
    }

    public func clamp(_ colour: OKLCh) -> OKLCh
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
