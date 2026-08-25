import Testing

@testable import Cascade
@testable import ThemeDomain
@testable import UserSheet

@Suite("A sheet Safari will honour")
struct UserStyleSheetTests
{
    private static let pairs = ThemePair.all(in: Theme.catalogue())

    private func text(_ pair: ThemePair) -> String
    {
        UserStyleSheet.sheet(for: pair).text
    }

    @Test("there is one sheet for each of the nine presets")
    func everyPresetPairs()
    {
        #expect(UserStyleSheetTests.pairs.count == 9)
    }

    @Test("every declaration outranks the page",
          arguments: UserStyleSheetTests.pairs)
    func everyDeclarationIsImportant(pair: ThemePair)
    {
        for line in text(pair).split(separator: "\n")
        {
            guard line.hasSuffix(";") else
            {
                continue
            }
            #expect(line.contains("!important"), "\(pair.name): \(line)")
        }
    }

    @Test("the sheet carries neither of the two rules that break it",
          arguments: UserStyleSheetTests.pairs)
    func noImportAndNoLayer(pair: ThemePair)
    {
        let sheet = text(pair)
        #expect(!sheet.contains("@import"))
        #expect(!sheet.contains("@layer"))
    }

    @Test("light and dark define exactly the same roles",
          arguments: UserStyleSheetTests.pairs)
    func bothAppearancesAgree(pair: ThemePair)
    {
        let light = Tokens.rule(for: pair.light).declarations
        let dark = Tokens.rule(for: pair.dark).declarations
        #expect(light.map { $0.property } == dark.map { $0.property })
        #expect(light.count == PaletteName.allCases.count)
    }
}
