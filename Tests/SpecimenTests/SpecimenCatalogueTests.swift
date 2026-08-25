import Foundation
import Testing

@testable import Specimen
@testable import ThemeDomain

@Suite("One page, every theme, every role")
struct SpecimenCatalogueTests
{
    private static let themes = Theme.catalogue()
    private static let page = SpecimenCatalogue.page(for: themes)

    @Test("every theme has a scope and a pick on the page")
    func everyThemeIsReachable()
    {
        for theme in Self.themes
        {
            let id = theme.identifier
            #expect(Self.page.contains("[data-theme=\"\(id)\"]"), "\(id)")
            #expect(Self.page.contains("data-pick=\"\(id)\""), "\(id)")
        }
    }

    @Test("there is one swatch per role")
    func oneSwatchPerRole()
    {
        let swatches = SpecimenCatalogue.swatches()
        let pieces = swatches.components(separatedBy: "class=\"swatch\"")
        #expect(pieces.count - 1 == PaletteName.allCases.count)
    }

    @Test("the readings are JSON, one entry per theme and per role")
    func readingsAreJSON() throws
    {
        let data = Data(SpecimenCatalogue.readings(for: Self.themes).utf8)
        let parsed = try JSONSerialization.jsonObject(with: data)
        let byTheme = try #require(parsed as? [String: [String: Double]])
        #expect(byTheme.count == Self.themes.count)
        for (id, roles) in byTheme
        {
            #expect(roles.count == PaletteName.allCases.count, "\(id)")
            #expect(roles["text"]! > 90, "\(id)")
            #expect(roles["background"]! == 0, "\(id)")
        }
    }

    @Test("no family placeholder survives into the layout")
    func familiesAreResolved()
    {
        #expect(!SpecimenCatalogue.layout().contains("FAMILY_"))
        #expect(SpecimenCatalogue.layout().contains(SpecimenPage.serifStack))
    }
}
