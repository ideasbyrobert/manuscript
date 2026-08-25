import Testing

@testable import AppleColors
@testable import Pigment
@testable import ThemeDomain

@Suite("Sunrise: yellow keywords on straw")
struct SunrisePresetTests
{
    private let preset = Preset.sunrise

    @Test("it is named, hued and tinted as its file says")
    func identity()
    {
        #expect(preset.id == "sunrise")
        #expect(preset.title == "Sunrise")
        #expect(preset.tintHue == Hue(degrees: 88))
        #expect(preset.lightTint == Chroma(0.0135))
        #expect(preset.darkTint == Chroma(0.0160))
        #expect(preset.overrides.isEmpty)
    }

    @Test("its inks are the system colours it names")
    func inks()
    {
        #expect(preset.ink(for: .keyword) == .yellow)
        #expect(preset.ink(for: .type) == .orange)
        #expect(preset.ink(for: .alternateType) == .brown)
        #expect(preset.ink(for: .member) == .green)
        #expect(preset.ink(for: .alternateMember) == .orange)
        #expect(preset.ink(for: .string) == .teal)
        #expect(preset.ink(for: .number) == .blue)
        #expect(preset.ink(for: .preprocessor) == .brown)
        #expect(preset.ink(for: .link) == .blue)
    }
}
