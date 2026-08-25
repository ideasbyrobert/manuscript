import Testing

@testable import Pigment
@testable import ThemeDomain

@Suite("A complete palette")
struct PaletteTests
{
    private func full() -> Palette
    {
        var swatches: [PaletteName: SRGB] = [:]
        for name in PaletteName.allCases
        {
            swatches[name] = SRGB(hexNotation: "#808080")!
        }
        swatches[.background] = SRGB(hexNotation: "#ffffff")!
        swatches[.text] = SRGB(hexNotation: "#000000")!
        return Palette(swatches: swatches)
    }

    @Test("every role can be read back")
    func everyRoleResolves()
    {
        let palette = full()
        for name in PaletteName.allCases
        {
            #expect(palette[name].isWithinGamut, "\(name)")
        }
    }

    @Test("notation is the hex of the swatch")
    func notationMatches()
    {
        #expect(full().notation(.background) == "#ffffff")
    }

    @Test("contrast is measured against the ground by default")
    func contrastDefaultsToGround()
    {
        let measured = full().contrast(.text)
        #expect(abs(measured.value - 21) < 1e-9)
    }

    @Test("contrast can be measured against any other role")
    func contrastAcceptsAnyGround()
    {
        let measured = full().contrast(.text, against: .text)
        #expect(abs(measured.value - 1) < 1e-9)
    }
}
