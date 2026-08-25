import Testing

@testable import lint

@Suite("What a line of source says about itself")
struct SourceLineTests
{
    @Test("width counts characters, so a dash costs one")
    func widthIsInCharacters()
    {
        let tail = String(repeating: "a", count: 78)
        let line = SourceLine(number: 1, text: "— " + tail)
        #expect(line.width == 80)
    }

    @Test("a comment inside a string is not a comment")
    func quotedSlashesAreNotComments()
    {
        let line = SourceLine(number: 1, text: "let url = \"https://x\"")
        #expect(!line.carriesComment)
        #expect(SourceLine(number: 1, text: "let x = 1 // no").carriesComment)
    }

    @Test("the tools directive is the one comment allowed")
    func toolsVersionIsExempt()
    {
        let line = SourceLine(number: 1, text: "// swift-tools-version: 6.4")
        #expect(!line.carriesComment)
    }

    @Test("a trailing closure is not an opening brace")
    func trailingClosuresAreNotBraces()
    {
        let closure = SourceLine(number: 1, text: "items.map { $0.name }")
        let opening = SourceLine(number: 1, text: "func widen() {")
        #expect(!closure.opensBraceOnSameLine)
        #expect(opening.opensBraceOnSameLine)
    }
}
