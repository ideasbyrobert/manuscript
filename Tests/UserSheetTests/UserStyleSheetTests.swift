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
        let light = Tokens.rule(for: pair.light, on: [":root"]).declarations
        let dark = Tokens.rule(for: pair.dark, on: [":root"]).declarations
        #expect(light.map { $0.property } == dark.map { $0.property })
        #expect(light.count == PaletteName.allCases.count)
    }

    @Test("a sheet that paints nothing is not a sheet",
          arguments: UserStyleSheetTests.pairs)
    func theSheetActuallyPaints(pair: ThemePair)
    {
        let sheet = text(pair)
        for signature in [
            ".hljs-keyword",
            ".token.keyword",
            "pre.codehilite) .k",
            "--prettylights-syntax-keyword",
            "--manuscript-keyword"]
        {
            #expect(sheet.contains(signature), "missing \(signature)")
        }
    }

    @Test("dark is stated after light, which is what makes it win",
          arguments: UserStyleSheetTests.pairs)
    func darkFollowsLight(pair: ThemePair)
    {
        let sheet = text(pair)
        guard let light = sheet.range(of: ":root"),
              let dark = sheet.range(of: "@media (prefers-color-scheme")
        else
        {
            Issue.record("the sheet states neither appearance")
            return
        }
        #expect(light.lowerBound < dark.lowerBound)
    }

    @Test("a token carries the colour its role was solved to",
          arguments: UserStyleSheetTests.pairs)
    func tokensCarryTheColourTheyName(pair: ThemePair)
    {
        let sheet = text(pair)
        for role in PaletteName.allCases
        {
            let solved = pair.light.palette.notation(role)
            let stated = "--manuscript-\(role.rawValue): \(solved)"
            #expect(sheet.contains(stated), "\(role) drifted")
        }
    }
    @Test("the bridge reaches where GitHub declares its own tokens",
          arguments: UserStyleSheetTests.pairs)
    func theBridgeReachesThemedElements(pair: ThemePair)
    {
        let sheet = text(pair)
        #expect(
            sheet.contains("[data-color-mode]"),
            "a :root bridge supplies nothing to a themed descendant")
    }

    @Test("an emphasised line is marked without a second ground",
          arguments: UserStyleSheetTests.pairs)
    func theBandMarksWithoutFilling(pair: ThemePair)
    {
        let sheet = text(pair)
        #expect(
            sheet.contains("box-shadow: inset 3px 0 0"),
            "an emphasised line carries no mark at all")
        #expect(
            sheet.contains("background-color: transparent"),
            "the ground the page painted survives under our ink")
    }

    @Test("a page that declares its own scheme is believed over the system",
          arguments: UserStyleSheetTests.pairs)
    func aDeclaredSchemeWins(pair: ThemePair)
    {
        let sheet = text(pair)
        let darkKeyword = pair.dark.palette.notation(.keyword)
        let lightKeyword = pair.light.palette.notation(.keyword)
        guard let declaredDark = sheet.range(of: "[data-theme=\"dark\"]"),
              let declaredLight = sheet.range(of: "[data-theme=\"light\"]"),
              let system = sheet.range(of: "@media (prefers-color-scheme")
        else
        {
            Issue.record("the sheet never listens to the page")
            return
        }
        let afterDark = sheet[declaredDark.upperBound...]
        let afterLight = sheet[declaredLight.upperBound...]
        #expect(afterDark.contains("--manuscript-keyword: " + darkKeyword))
        #expect(afterLight.contains("--manuscript-keyword: " + lightKeyword))
        #expect(
            system.lowerBound < declaredLight.lowerBound,
            "a page declared light must outrank a system that says dark")
    }
}
