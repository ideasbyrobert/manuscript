import Testing

@testable import Cascade
@testable import Highlighters

@Suite("A highlighter names its containers, its tokens and its resets")
struct HighlighterTests
{
    @Test("what is given is kept, in order")
    func keepsWhatItIsGiven()
    {
        let reset = Rule([".x"], [Declaration("color", "inherit")])
        let made = Highlighter(
            name: "probe",
            containers: ["pre.a", "code.b"],
            bindings: [TokenBinding([".k"], .keyword, .bold)],
            resets: [reset])
        #expect(made.name == "probe")
        #expect(made.containers == ["pre.a", "code.b"])
        #expect(made.bindings.count == 1)
        #expect(made.bindings[0].emphasis == .bold)
        #expect(made.resets.count == 1)
        #expect(made.resets[0].selectors == [".x"])
    }

    @Test("resets are optional and default to none")
    func resetsDefaultToNone()
    {
        let made = Highlighter(name: "bare", containers: [], bindings: [])
        #expect(made.resets.isEmpty)
    }
}
