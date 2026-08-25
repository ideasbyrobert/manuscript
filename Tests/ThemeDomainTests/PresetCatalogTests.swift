import Testing

@testable import AppleColors
@testable import ThemeDomain

@Suite("The catalogue of presets")
struct PresetCatalogTests
{
    @Test("there are nine, matching the Xcode preset grid")
    func ninePresets()
    {
        #expect(PresetCatalog.all.count == 9)
    }

    @Test("no two presets share an identifier or a title")
    func identityIsUnique()
    {
        let identifiers = PresetCatalog.all.map(\.id)
        let titles = PresetCatalog.all.map(\.title)
        #expect(Set(identifiers).count == identifiers.count)
        #expect(Set(titles).count == titles.count)
    }

    @Test("a preset answers to its identifier and to its title")
    func lookupWorksEitherWay()
    {
        for preset in PresetCatalog.all
        {
            #expect(PresetCatalog.named(preset.id)?.id == preset.id)
            #expect(PresetCatalog.named(preset.title)?.id == preset.id)
        }
    }

    @Test("lookup is indifferent to case")
    func lookupIgnoresCase()
    {
        #expect(PresetCatalog.named("EMBER")?.id == "ember")
        #expect(PresetCatalog.named("Coral Reef")?.id == "coral-reef")
    }

    @Test("an unknown name finds nothing")
    func unknownFindsNothing()
    {
        #expect(PresetCatalog.named("burgundy") == nil)
    }

    @Test("every preset fills every ink slot", arguments: PresetCatalog.all)
    func slotsAreFilled(preset: Preset)
    {
        for slot in InkSlot.allCases
        {
            #expect(preset.inks[slot] != nil, "\(preset.id) lacks \(slot)")
        }
    }

    @Test("no preset paints strings and keywords the same")
    func stringsDifferFromKeywords()
    {
        for preset in PresetCatalog.all
        {
            #expect(
                preset.ink(for: .string) != preset.ink(for: .keyword),
                "\(preset.id)")
        }
    }

    @Test("identifiers are lowercase and hyphenated")
    func identifiersAreWellFormed()
    {
        for preset in PresetCatalog.all
        {
            let allowed = Set("abcdefghijklmnopqrstuvwxyz-")
            #expect(preset.id.allSatisfy(allowed.contains), "\(preset.id)")
        }
    }
}
