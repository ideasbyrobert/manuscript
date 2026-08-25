import Testing

@testable import AppleColors
@testable import Pigment
@testable import ThemeDomain

@Suite("Cobalt: blue keywords on slate")
struct CobaltPresetTests
{
    private let preset = Preset.cobalt

    @Test("it is named, hued and tinted as its file says")
    func identity()
    {
        #expect(preset.id == "cobalt")
        #expect(preset.title == "Cobalt")
        #expect(preset.tintHue == Hue(degrees: 288))
        #expect(preset.lightTint == Chroma(0.0110))
        #expect(preset.darkTint == Chroma(0.0190))
        #expect(preset.overrides.isEmpty)
    }

    @Test("its inks are the system colours it names")
    func inks()
    {
        #expect(preset.ink(for: .keyword) == .blue)
        #expect(preset.ink(for: .type) == .indigo)
        #expect(preset.ink(for: .alternateType) == .purple)
        #expect(preset.ink(for: .member) == .cyan)
        #expect(preset.ink(for: .alternateMember) == .teal)
        #expect(preset.ink(for: .string) == .orange)
        #expect(preset.ink(for: .number) == .yellow)
        #expect(preset.ink(for: .preprocessor) == .pink)
        #expect(preset.ink(for: .link) == .blue)
    }
}
