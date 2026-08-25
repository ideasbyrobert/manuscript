import Testing

@testable import AppleColors
@testable import Pigment
@testable import ThemeDomain

@Suite("Ember: red keywords on cream")
struct EmberPresetTests
{
    private let preset = Preset.ember

    @Test("it is named, hued and tinted as its file says")
    func identity()
    {
        #expect(preset.id == "ember")
        #expect(preset.title == "Ember")
        #expect(preset.tintHue == Hue(degrees: 52))
        #expect(preset.lightTint == Chroma(0.0120))
        #expect(preset.darkTint == Chroma(0.0150))
        #expect(preset.overrides.isEmpty)
    }

    @Test("its inks are the system colours it names")
    func inks()
    {
        #expect(preset.ink(for: .keyword) == .red)
        #expect(preset.ink(for: .type) == .orange)
        #expect(preset.ink(for: .alternateType) == .red)
        #expect(preset.ink(for: .member) == .brown)
        #expect(preset.ink(for: .alternateMember) == .orange)
        #expect(preset.ink(for: .string) == .purple)
        #expect(preset.ink(for: .number) == .blue)
        #expect(preset.ink(for: .preprocessor) == .orange)
        #expect(preset.ink(for: .link) == .blue)
    }
}
