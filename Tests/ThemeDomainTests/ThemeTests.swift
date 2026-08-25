import Testing

@testable import AppleColors
@testable import Pigment
@testable import ThemeDomain

@Suite("Every theme resolves completely")
struct ThemeTests
{
    @Test("the catalogue is nine presets in two appearances")
    func catalogueSize()
    {
        #expect(Theme.catalogue().count == 18)
    }

    @Test("every identifier is unique")
    func identifiersAreUnique()
    {
        let identifiers = Theme.catalogue().map(\.identifier)
        #expect(Set(identifiers).count == identifiers.count)
    }

    @Test("every swatch lands inside the cube", arguments: Theme.catalogue())
    func swatchesAreLegal(theme: Theme)
    {
        for name in PaletteName.allCases
        {
            #expect(theme.palette[name].isWithinGamut, "\(theme) \(name)")
        }
    }

    @Test("a theme prints as its identifier")
    func printsAsIdentifier()
    {
        let theme = Theme(preset: .ember, appearance: .light)
        #expect("\(theme)" == "ember-light")
    }

    @Test("resolution is deterministic")
    func resolutionIsRepeatable()
    {
        let once = Theme(preset: .ember, appearance: .light)
        let twice = Theme(preset: .ember, appearance: .light)
        for name in PaletteName.allCases
        {
            #expect(once.palette[name] == twice.palette[name], "\(name)")
        }
    }

    @Test("the ground follows the appearance", arguments: PresetCatalog.all)
    func groundFollowsAppearance(preset: Preset)
    {
        let light = Theme(preset: preset, appearance: .light)
        let dark = Theme(preset: preset, appearance: .dark)
        let lightGround = OKLCh(light.palette[.background]).lightness
        let darkGround = OKLCh(dark.palette[.background]).lightness
        #expect(lightGround > darkGround)
    }
}
