import Testing

@testable import AppleColors
@testable import Pigment
@testable import ThemeDomain

@Suite("Emerald: green keywords on moss")
struct EmeraldPresetTests
{
    private let preset = Preset.emerald

    @Test("it is named, hued and tinted as its file says")
    func identity()
    {
        #expect(preset.id == "emerald")
        #expect(preset.title == "Emerald")
        #expect(preset.tintHue == Hue(degrees: 148))
        #expect(preset.lightTint == Chroma(0.0125))
        #expect(preset.darkTint == Chroma(0.0170))
        #expect(preset.overrides.isEmpty)
    }

    @Test("its inks are the system colours it names")
    func inks()
    {
        #expect(preset.ink(for: .keyword) == .green)
        #expect(preset.ink(for: .type) == .brown)
        #expect(preset.ink(for: .alternateType) == .orange)
        #expect(preset.ink(for: .member) == .teal)
        #expect(preset.ink(for: .alternateMember) == .green)
        #expect(preset.ink(for: .string) == .purple)
        #expect(preset.ink(for: .number) == .indigo)
        #expect(preset.ink(for: .preprocessor) == .brown)
        #expect(preset.ink(for: .link) == .blue)
    }
}
