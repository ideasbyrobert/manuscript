import Testing

@testable import AppleColors
@testable import ThemeDomain
@testable import UserSheet

@Suite("The two halves of one preset")
struct ThemePairTests
{
    private static let pairs = ThemePair.all(in: Theme.catalogue())

    @Test("each half is the appearance it is named for",
          arguments: ThemePairTests.pairs)
    func eachHalfIsItsOwnAppearance(pair: ThemePair)
    {
        #expect(pair.light.appearance == .light)
        #expect(pair.dark.appearance == .dark)
    }

    @Test("both halves are the same preset", arguments: ThemePairTests.pairs)
    func bothHalvesShareAPreset(pair: ThemePair)
    {
        #expect(pair.light.identifier == pair.name + "-light")
        #expect(pair.dark.identifier == pair.name + "-dark")
    }

    @Test("a preset that does not exist pairs with nothing")
    func anUnknownPresetRefusesToPair()
    {
        #expect(ThemePair(preset: "nonesuch", in: Theme.catalogue()) == nil)
    }

    @Test("the nine cover the eighteen exactly")
    func theNineCoverTheEighteen()
    {
        let themes = Theme.catalogue()
        #expect(themes.count == 18)
        #expect(ThemePairTests.pairs.count == 9)
    }
}
