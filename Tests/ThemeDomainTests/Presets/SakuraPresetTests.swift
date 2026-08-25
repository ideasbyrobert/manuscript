import Testing

@testable import AppleColors
@testable import Pigment
@testable import ThemeDomain

@Suite("Sakura: pink keywords on blush")
struct SakuraPresetTests
{
    private let preset = Preset.sakura

    @Test("it is named, hued and tinted as its file says")
    func identity()
    {
        #expect(preset.id == "sakura")
        #expect(preset.title == "Sakura")
        #expect(preset.tintHue == Hue(degrees: 340))
        #expect(preset.lightTint == Chroma(0.0130))
        #expect(preset.darkTint == Chroma(0.0170))
        #expect(preset.overrides.isEmpty)
    }

    @Test("its inks are the system colours it names")
    func inks()
    {
        #expect(preset.ink(for: .keyword) == .pink)
        #expect(preset.ink(for: .type) == .purple)
        #expect(preset.ink(for: .alternateType) == .indigo)
        #expect(preset.ink(for: .member) == .red)
        #expect(preset.ink(for: .alternateMember) == .brown)
        #expect(preset.ink(for: .string) == .indigo)
        #expect(preset.ink(for: .number) == .blue)
        #expect(preset.ink(for: .preprocessor) == .brown)
        #expect(preset.ink(for: .link) == .blue)
    }
}
