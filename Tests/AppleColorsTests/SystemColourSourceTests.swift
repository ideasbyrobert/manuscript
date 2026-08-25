import Testing

@testable import AppleColors
@testable import Pigment

@Suite("Any source of system colour may stand in for AppKit")
struct SystemColourSourceTests
{
    private struct Marked: SystemColourSource
    {
        func colour(_ colour: SystemColour, in appearance: Appearance) -> SRGB
        {
            let lit = appearance == .dark ? 1.0 : 0.0
            return SRGB(red: lit, green: 0, blue: 0)
        }
    }

    @Test("a source is asked per appearance, through the existential")
    func askedPerAppearance()
    {
        let source: any SystemColourSource = Marked()
        #expect(source.colour(.blue, in: .dark).red == 1)
        #expect(source.colour(.blue, in: .light).red == 0)
    }

    @Test("the recorded colours are one such source")
    func recordedConforms()
    {
        let source: any SystemColourSource = RecordedSystemColours.macOS27
        let expected = SRGB(hexNotation: "#FF383C")
        #expect(source.colour(.red, in: .light) == expected)
    }
}
