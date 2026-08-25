import Testing

@testable import Typography

@Suite("Upright or italic")
struct TypeSlantTests
{
    @Test("upright adds nothing to a name; italic adds the word")
    func suffixes()
    {
        #expect(TypeSlant.upright.suffix == "")
        #expect(TypeSlant.italic.suffix == "Italic")
    }

    @Test("there are two, and upright comes first")
    func order()
    {
        #expect(TypeSlant.allCases == [.upright, .italic])
    }
}
