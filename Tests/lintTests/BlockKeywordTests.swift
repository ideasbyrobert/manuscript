import Testing

@testable import lint

@Suite("Words that open a block")
struct BlockKeywordTests
{
    @Test("modifiers are stripped before the keyword is read")
    func modifiersAreStripped()
    {
        #expect(BlockKeyword.stripped("  package static func f") == "func f")
        #expect(BlockKeyword.opens("private final class C"))
    }

    @Test("a keyword must end where a keyword ends")
    func keywordsAreWholeWords()
    {
        #expect(!BlockKeyword.opens("structure = 1"))
        #expect(BlockKeyword.opens("struct A"))
        #expect(BlockKeyword.opens("func f<T>()"))
    }
}
