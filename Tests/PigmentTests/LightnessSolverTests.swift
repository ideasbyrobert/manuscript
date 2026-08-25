import Testing

@testable import Pigment

@Suite("Solving lightness for a contrast target")
struct LightnessSolverTests
{
    private func colour(_ notation: String) throws -> SRGB
    {
        try #require(SRGB(hexNotation: notation))
    }

    private func solved(
        on ground: SRGB,
        reaching target: ContrastRatio,
        hue: Double = 25,
        chroma: Double = 0.1) -> SRGB
    {
        let lightness = LightnessSolver(ground: ground).lightnessReaching(
            target,
            hue: Hue(degrees: hue),
            chroma: Chroma(chroma))
        return OKLCh(
            lightness: lightness,
            chroma: Chroma(chroma),
            hue: Hue(degrees: hue)).srgb
    }

    @Test(
        "the solved ink reaches its target on a light ground",
        arguments: [3.0, 4.5, 7.0, 10.0])
    func reachesTargetOnLight(target: Double) throws
    {
        let ground = try colour("#fff7f2")
        let ink = solved(on: ground, reaching: ContrastRatio(target))
        let measured = ContrastRatio.between(ink, ground).value
        #expect(measured >= target - 0.05)
    }

    @Test(
        "the solved ink reaches its target on a dark ground",
        arguments: [3.0, 4.5, 7.0, 10.0])
    func reachesTargetOnDark(target: Double) throws
    {
        let ground = try colour("#1e1612")
        let ink = solved(on: ground, reaching: ContrastRatio(target))
        let measured = ContrastRatio.between(ink, ground).value
        #expect(measured >= target - 0.05)
    }

    @Test("a light ground yields a darker ink")
    func darkensOnLight() throws
    {
        let ground = try colour("#fff7f2")
        let ink = solved(on: ground, reaching: 5.0)
        #expect(OKLCh(ink).lightness < OKLCh(ground).lightness)
    }

    @Test("a dark ground yields a lighter ink")
    func lightensOnDark() throws
    {
        let ground = try colour("#1e1612")
        let ink = solved(on: ground, reaching: 5.0)
        #expect(OKLCh(ink).lightness > OKLCh(ground).lightness)
    }

    @Test("the solved ink keeps the hue it was asked for")
    func keepsHue() throws
    {
        let ground = try colour("#fff7f2")
        for degrees in stride(from: 0.0, to: 360.0, by: 29.0)
        {
            let ink = solved(on: ground, reaching: 5.0, hue: degrees)
            let apart = OKLCh(ink).hue.separation(from: Hue(degrees: degrees))
            #expect(apart < 2)
        }
    }

    @Test("a higher target never yields a lighter ink on light ground")
    func targetIsMonotonic() throws
    {
        let ground = try colour("#fff7f2")
        var previous = Lightness.lightest
        for target in [2.0, 3.0, 4.5, 7.0, 12.0]
        {
            let ink = solved(on: ground, reaching: ContrastRatio(target))
            let lightness = OKLCh(ink).lightness
            #expect(lightness <= previous)
            previous = lightness
        }
    }
}
