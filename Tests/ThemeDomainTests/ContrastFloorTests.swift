import AppleColors
import Pigment
import Testing

@testable import ThemeDomain

@Suite("Contrast floors hold in every theme")
struct ContrastFloorTests
{
    private static let floors: [PaletteName: ContrastRatio] =
    [
        .text: 10.0,
        .keyword: 5.5,
        .type: 4.5,
        .member: 4.5,
        .string: 4.5,
        .number: 4.5,
        .preprocessor: 4.5,
        .link: 4.5,
        .softKeyword: 4.5,
        .alternateType: 4.5,
        .alternateMember: 4.5,
        .alternateString: 4.5,
        .namespace: 4.5,
        .label: 4.5,
        .comment: 3.0,
        .documentation: 3.0,
        .punctuation: 4.0,
        .operator: 5.5,
        .error: 4.0,
        .warning: 3.6,
        .information: 4.0,
        .hint: 3.6,
        .addition: 4.0,
        .removal: 4.0,
        .modification: 4.0
    ]

    private static let bands: [PaletteName: ClosedRange<Double>] =
    [
        .whitespace: 1.5 ... 2.6,
        .indentGuide: 1.2 ... 1.9,
        .ghostText: 1.8 ... 2.5
    ]

    @Test("readable roles clear their floor", arguments: Theme.catalogue())
    func floorsHold(theme: Theme)
    {
        for (name, floor) in Self.floors
        {
            let measured = theme.palette.contrast(name)
            #expect(
                measured >= floor,
                "\(theme) \(name) is \(measured.value)")
        }
    }

    @Test("furniture stays quiet", arguments: Theme.catalogue())
    func furnitureRecedes(theme: Theme)
    {
        for (name, band) in Self.bands
        {
            let measured = theme.palette.contrast(name).value
            #expect(band.contains(measured), "\(theme) \(name) is \(measured)")
        }
    }

    @Test("frequent tokens stay apart", arguments: Theme.catalogue())
    func tokensAreDistinguishable(theme: Theme)
    {
        let frequent: [PaletteName] = [.keyword, .type, .string, .number]
        for one in frequent
        {
            for other in frequent where other != one
            {
                let first = OKLCh(theme.palette[one])
                let second = OKLCh(theme.palette[other])
                let confusable = first.hue.separation(from: second.hue) < 8
                    && first.lightness.distance(to: second.lightness) < 0.06
                #expect(!confusable, "\(theme): \(one) and \(other)")
            }
        }
    }

    @Test("the caret stays Apple blue in every light theme")
    func caretIsBlue()
    {
        for theme in Theme.catalogue() where theme.appearance == .light
        {
            #expect(theme.palette.notation(.cursor) == "#007aff")
        }
    }

    @Test("a hue survives the move between grounds")
    func hueSurvivesTheGround()
    {
        for preset in PresetCatalog.all
        {
            let light = Theme(preset: preset, appearance: .light)
            let dark = Theme(preset: preset, appearance: .dark)
            for name in [PaletteName.keyword, .type, .string, .number]
            {
                let apart = OKLCh(light.palette[name]).hue
                    .separation(from: OKLCh(dark.palette[name]).hue)
                #expect(apart < 12, "\(preset.id) \(name) moved \(apart)")
            }
        }
    }
}
