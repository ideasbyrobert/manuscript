import Testing

@testable import Pigment
@testable import ThemeDomain

@Suite("What is measured is what is written")
struct PaletteFidelityTests
{
    @Test("every swatch survives its own notation",
          arguments: Theme.catalogue())
    func swatchesSurviveNotation(theme: Theme)
    {
        for name in PaletteName.allCases
        {
            let written = SRGB(hexNotation: theme.palette.notation(name))
            let stored = theme.palette[name]
            #expect(written != nil, "\(theme) \(name)")
            guard let written else { continue }
            #expect(
                ContrastRatio.between(written, theme.palette[.background])
                    == theme.palette.contrast(name),
                "\(theme) \(name) drifts on the way out")
            #expect(abs(written.red - stored.red) < 1e-12)
            #expect(abs(written.green - stored.green) < 1e-12)
            #expect(abs(written.blue - stored.blue) < 1e-12)
        }
    }
}
