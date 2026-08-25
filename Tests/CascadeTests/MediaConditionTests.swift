import Testing

@testable import Cascade

@Suite("Asking the system which way it is set")
struct MediaConditionTests
{
    @Test("each appearance names the preference Safari evaluates",
          arguments: MediaCondition.allCases)
    func conditionNamesThePreference(condition: MediaCondition)
    {
        #expect(condition.text
            == "(prefers-color-scheme: \(condition.rawValue))")
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
