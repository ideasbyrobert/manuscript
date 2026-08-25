import Testing

@testable import Cascade

@Suite("Asking the system which way it is set")
struct MediaConditionTests
{
    @Test("each appearance yields a distinct, parenthesised query")
    func conditionsAreDistinctQueries()
    {
        let texts = MediaCondition.allCases.map { $0.text }
        #expect(Set(texts).count == texts.count)
        for text in texts
        {
            #expect(text.hasPrefix("(") && text.hasSuffix(")"))
        }
    }

    @Test("there are exactly two, and they are light and dark")
    func thereAreOnlyTwo()
    {
        #expect(MediaCondition.allCases.count == 2)
        #expect(MediaCondition.light.text
            == "(prefers-color-scheme: light)")
        #expect(MediaCondition.dark.text
            == "(prefers-color-scheme: dark)")
    }
}
