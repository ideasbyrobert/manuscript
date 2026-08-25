import Testing

@testable import AppleColors
@testable import Pigment
@testable import ThemeDomain

@Suite("Standard: purple keywords on a cool white")
struct StandardPresetTests
{
    private let preset = Preset.standard

    @Test("it is named, hued and tinted as its file says")
    func identity()
    {
        #expect(preset.id == "standard")
        #expect(preset.title == "Standard")
        #expect(preset.tintHue == Hue(degrees: 258))
        #expect(preset.lightTint == Chroma(0.0030))
        #expect(preset.darkTint == Chroma(0.0060))
        #expect(preset.overrides == [.type: 87])
    }

    @Test("its inks are the system colours it names")
    func inks()
    {
        #expect(preset.ink(for: .keyword) == .purple)
        #expect(preset.ink(for: .type) == .indigo)
        #expect(preset.ink(for: .alternateType) == .blue)
        #expect(preset.ink(for: .member) == .teal)
        #expect(preset.ink(for: .alternateMember) == .cyan)
        #expect(preset.ink(for: .string) == .red)
        #expect(preset.ink(for: .number) == .indigo)
        #expect(preset.ink(for: .preprocessor) == .brown)
        #expect(preset.ink(for: .link) == .blue)
    }
}
