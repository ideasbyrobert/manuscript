import Foundation
import Testing

@testable import Specimen
@testable import ThemeDomain

@Suite("The specimen names only roles the palette holds")
struct SpecimenTextTests
{
    @Test("every marked run in the code parses to a real role")
    func codeParses()
    {
        var roles: Set<PaletteName> = []
        for line in SpecimenText.code
        {
            for token in SpecimenMarkup.tokens(in: line)
            {
                if let role = token.role
                {
                    roles.insert(role)
                }
            }
        }
        #expect(roles.count >= 16)
        #expect(roles.contains(.documentation))
        #expect(roles.contains(.link))
    }

    @Test("a brace outside a mark is a brace of the code itself")
    func bracesOutsideMarksAreCode()
    {
        for line in SpecimenText.code
        {
            let tokens = SpecimenMarkup.tokens(in: line)
            for token in tokens where token.role == nil
            {
                let trimmed = token.text.trimmingCharacters(in: .whitespaces)
                if trimmed.contains("{") || trimmed.contains("}")
                {
                    #expect(trimmed == "{" || trimmed == "}", "\(line)")
                }
            }
        }
    }

    @Test("the prose is there to be set")
    func proseIsPresent()
    {
        #expect(SpecimenText.book.count == 3)
        #expect(SpecimenText.book[0].hasPrefix("Call me Ishmael."))
        #expect(SpecimenText.editorialBody.count == 2)
        #expect(SpecimenText.captions.count == 3)
        #expect(SpecimenText.bookAuthor.hasSuffix("1851"))
    }
}
