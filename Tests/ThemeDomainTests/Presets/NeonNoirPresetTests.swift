import Testing

@testable import AppleColors
@testable import Pigment
@testable import ThemeDomain

@Suite("Neon Noir: purple keywords on violet")
struct NeonNoirPresetTests
{
    private let preset = Preset.neonNoir

    @Test("it is named, hued and tinted as its file says")
    func identity()
    {
        #expect(preset.id == "neon-noir")
        #expect(preset.title == "Neon Noir")
        #expect(preset.tintHue == Hue(degrees: 302))
        #expect(preset.lightTint == Chroma(0.0130))
        #expect(preset.darkTint == Chroma(0.0200))
        #expect(preset.overrides.isEmpty)
    }

    @Test("its inks are the system colours it names")
    func inks()
    {
        #expect(preset.ink(for: .keyword) == .purple)
        #expect(preset.ink(for: .type) == .indigo)
        #expect(preset.ink(for: .alternateType) == .pink)
        #expect(preset.ink(for: .member) == .blue)
        #expect(preset.ink(for: .alternateMember) == .cyan)
        #expect(preset.ink(for: .string) == .mint)
        #expect(preset.ink(for: .number) == .cyan)
        #expect(preset.ink(for: .preprocessor) == .pink)
        #expect(preset.ink(for: .link) == .cyan)
    }
}
