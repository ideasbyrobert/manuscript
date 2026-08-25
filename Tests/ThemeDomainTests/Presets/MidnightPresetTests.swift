import Testing

@testable import AppleColors
@testable import Pigment
@testable import ThemeDomain

@Suite("Midnight: blue keywords on a deep tint")
struct MidnightPresetTests
{
    private let preset = Preset.midnight

    @Test("it is named, hued and tinted as its file says")
    func identity()
    {
        #expect(preset.id == "midnight")
        #expect(preset.title == "Midnight")
        #expect(preset.tintHue == Hue(degrees: 240))
        #expect(preset.lightTint == Chroma(0.0200))
        #expect(preset.darkTint == Chroma(0.0245))
        #expect(preset.overrides.isEmpty)
    }

    @Test("its inks are the system colours it names")
    func inks()
    {
        #expect(preset.ink(for: .keyword) == .blue)
        #expect(preset.ink(for: .type) == .indigo)
        #expect(preset.ink(for: .alternateType) == .purple)
        #expect(preset.ink(for: .member) == .teal)
        #expect(preset.ink(for: .alternateMember) == .mint)
        #expect(preset.ink(for: .string) == .pink)
        #expect(preset.ink(for: .number) == .cyan)
        #expect(preset.ink(for: .preprocessor) == .indigo)
        #expect(preset.ink(for: .link) == .cyan)
    }
}
