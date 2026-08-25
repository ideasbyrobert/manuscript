import Testing

@testable import Highlighters

@Suite("Bold, italic, or neither")
struct EmphasisTests
{
    @Test("the catalogue asks for every kind somewhere")
    func everyKindIsAsked()
    {
        let asked = HighlighterCatalog.all
            .flatMap(\.bindings)
            .map(\.emphasis)
        #expect(asked.contains(.bold))
        #expect(asked.contains(.italic))
        #expect(asked.contains(.none))
    }

    @Test("most tokens carry none")
    func noneIsTheCommonCase()
    {
        let asked = HighlighterCatalog.all
            .flatMap(\.bindings)
            .map(\.emphasis)
        let plain = asked.filter { $0 == .none }.count
        #expect(plain * 2 > asked.count)
    }
}
