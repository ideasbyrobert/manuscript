import Testing

@testable import Cascade
@testable import ThemeDomain
@testable import UserSheet

@Suite("Names that cannot collide with a page's own")
struct TokenNameTests
{
    @Test("every role is namespaced", arguments: PaletteName.allCases)
    func everyRoleIsPrefixed(role: PaletteName)
    {
        #expect(TokenName.of(role).hasPrefix("--manuscript-"))
    }

    @Test("a reference asks for the name the token defines")
    func referenceMatchesDefinition()
    {
        #expect(TokenName.reference(.keyword)
            == "var(--manuscript-keyword)")
    }

    @Test("the sheet defines nothing a site might also define",
          arguments: ThemePair.all(in: Theme.catalogue()))
    func noGenericPropertyIsDefined(pair: ThemePair)
    {
        let sheet = UserStyleSheet.sheet(for: pair).text
        for line in sheet.split(separator: "\n")
        {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            guard trimmed.hasPrefix("--") else
            {
                continue
            }
            let ours = trimmed.hasPrefix("--manuscript-")
            let theirs = trimmed.hasPrefix("--prettylights-")
                || trimmed.hasPrefix("--color-prettylights-")
            #expect(ours || theirs, "ungoverned property: \(trimmed)")
        }
    }

    @Test("every colour a rule asks for is one the sheet defines",
          arguments: ThemePair.all(in: Theme.catalogue()))
    func everyReferenceResolves(pair: ThemePair)
    {
        let sheet = UserStyleSheet.sheet(for: pair).text
        let defined = Set(
            sheet.split(separator: "\n")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { $0.hasPrefix("--manuscript-") }
                .compactMap { $0.split(separator: ":").first }
                .map(String.init))
        #expect(!defined.isEmpty, "the sheet defines no token at all")
        var rest = Substring(sheet)
        while let opening = rest.range(of: "var(")
        {
            rest = rest[opening.upperBound...]
            guard let close = rest.firstIndex(of: ")") else
            {
                break
            }
            let asked = String(rest[rest.startIndex ..< close])
            #expect(defined.contains(asked), "undefined \(asked)")
            rest = rest[close...]
        }
    }

    @Test("every token the sheet defines is one some rule asks for",
          arguments: ThemePair.all(in: Theme.catalogue()))
    func everyDefinitionIsReferenced(pair: ThemePair)
    {
        let sheet = UserStyleSheet.sheet(for: pair).text
        for role in CodeSurface.roles
        {
            #expect(
                sheet.contains(TokenName.reference(role)),
                "\(role) is declared on every page and read by nothing")
        }
    }
}
