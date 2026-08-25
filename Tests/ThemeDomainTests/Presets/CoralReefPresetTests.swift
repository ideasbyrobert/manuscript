import Testing

@testable import AppleColors
@testable import Pigment
@testable import ThemeDomain

@Suite("Coral Reef: teal keywords on foam")
struct CoralReefPresetTests
{
    private let preset = Preset.coralReef

    @Test("it is named, hued and tinted as its file says")
    func identity()
    {
        #expect(preset.id == "coral-reef")
        #expect(preset.title == "Coral Reef")
        #expect(preset.tintHue == Hue(degrees: 192))
        #expect(preset.lightTint == Chroma(0.0125))
        #expect(preset.darkTint == Chroma(0.0175))
        #expect(preset.overrides.isEmpty)
    }

    @Test("its inks are the system colours it names")
    func inks()
    {
        #expect(preset.ink(for: .keyword) == .teal)
        #expect(preset.ink(for: .type) == .cyan)
        #expect(preset.ink(for: .alternateType) == .blue)
        #expect(preset.ink(for: .member) == .green)
        #expect(preset.ink(for: .alternateMember) == .mint)
        #expect(preset.ink(for: .string) == .pink)
        #expect(preset.ink(for: .number) == .orange)
        #expect(preset.ink(for: .preprocessor) == .purple)
        #expect(preset.ink(for: .link) == .blue)
    }
}
