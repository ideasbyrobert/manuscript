import Testing

@testable import ThemeDomain
@testable import UserSheet

@Suite("The sheet an author origin can win with")
struct AuthorSheetTests
{
    private func pair() -> ThemePair
    {
        ThemePair.all(in: Theme.catalogue()).first!
    }

    @Test("every selector carries the two floors that match nothing")
    func everySelectorIsFloored()
    {
        let text = AuthorSheet.text(for: pair())
        let head = text
            .split(separator: "\n")
            .filter { $0.hasPrefix(":root") || $0.contains(".token") }
        #expect(!head.isEmpty)
        for line in head
        {
            #expect(
                line.contains(":not(#manuscript-floor)"),
                "\(line)")
        }
    }

    @Test("every declaration in the sheet stays important")
    func everyDeclarationIsImportant()
    {
        let text = AuthorSheet.text(for: pair())
        let declarations = text
            .split(separator: "\n")
            .filter { $0.contains(": ") && $0.hasSuffix(";") }
        #expect(!declarations.isEmpty)
        for line in declarations
        {
            #expect(line.contains("!important;"), "\(line)")
        }
    }
}
