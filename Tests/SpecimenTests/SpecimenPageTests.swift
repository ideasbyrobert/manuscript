import Testing

@testable import Specimen
@testable import ThemeDomain

@Suite("A theme made visible")
struct SpecimenPageTests
{
    @Test("every role becomes a custom property",
          arguments: Theme.catalogue())
    func everyRoleIsNamed(theme: Theme)
    {
        let variables = SpecimenPage.variables(for: theme)
        for name in PaletteName.allCases
        {
            #expect(
                variables.contains("--\(name.rawValue):"),
                "\(theme) omits \(name)")
        }
    }
}
