import Testing

@testable import ThemeDomain
@testable import UserSheet

@Suite("One file per preset, named for it")
struct SheetFileTests
{
    private static let pairs = ThemePair.all(in: Theme.catalogue())

    @Test("the file is named for the preset alone",
          arguments: SheetFileTests.pairs)
    func namedForThePreset(pair: ThemePair)
    {
        #expect(SheetFile.name(for: pair) == pair.name + ".css")
        #expect(!SheetFile.name(for: pair).contains("light"))
        #expect(!SheetFile.name(for: pair).contains("dark"))
    }

    @Test("nine presets yield nine distinct names")
    func namesAreDistinct()
    {
        let names = SheetFileTests.pairs.map(SheetFile.name)
        #expect(Set(names).count == 9)
    }

    @Test("a file ends in exactly one newline", arguments: SheetFileTests.pairs)
    func endsInOneNewline(pair: ThemePair)
    {
        let text = SheetFile.text(for: pair)
        #expect(text.hasSuffix("}\n"))
        #expect(!text.hasSuffix("\n\n"))
    }
}
