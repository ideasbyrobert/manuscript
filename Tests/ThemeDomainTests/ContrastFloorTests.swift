import Testing

@testable import AppleColors
@testable import Pigment
@testable import ThemeDomain

@Suite("Contrast floors hold in every theme")
struct ContrastFloorTests
{
    private static let floors: [PaletteName: ContrastRatio] =
    [
        .text: 10.0,
        .dimText: 6.5,
        .faintText: 3.5,
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
        .whitespace: 28 ... 38,
        .indentGuide: 15 ... 24,
        .ghostText: 33 ... 45
    ]

    private static let grounds: [PaletteName] =
    [
        .background, .selection, .dimSelection, .matchingBracket,
        .searchHighlight, .cursorLine, .cursorColumn
    ]

    @Test("ink stays readable on every ground it may sit on",
          arguments: Theme.catalogue())
    func floorsHoldOnEveryGround(theme: Theme)
    {
        for ground in Self.grounds
        {
            for name in [PaletteName.text, .keyword, .type, .string,
                         .number, .comment]
            {
                let measured = theme.palette.contrast(name, against: ground)
                #expect(
                    measured >= 2.5,
                    "\(theme) \(name) on \(ground) is \(measured)")
            }
        }
    }

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

    @Test("floors hold on the inset ground a web page is painted with",
          arguments: Theme.catalogue())
    func floorsHoldOnTheInset(theme: Theme)
    {
        for (name, floor) in Self.floors
        {
            let measured = theme.palette.contrast(
                name,
                against: .insetBackground)
            #expect(
                measured >= floor,
                "\(theme) \(name) on inset is \(measured.value)")
        }
    }

    @Test("furniture stays quiet", arguments: Theme.catalogue())
    func furnitureRecedes(theme: Theme)
    {
        for (name, band) in Self.bands
        {
            let measured = Readability.between(
                theme.palette[name],
                theme.palette[.background]).magnitude
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
                let apart = OKLab(theme.palette[one])
                    .difference(from: OKLab(theme.palette[other]))
                #expect(
                    apart >= 0.04,
                    "\(theme): \(one) and \(other) differ by \(apart)")
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
