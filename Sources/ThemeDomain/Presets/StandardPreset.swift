import AppleColors

extension Preset
{
    static let standard = Preset(
        id: "standard",
        title: "Standard",
        tintHue: 258,
        lightTint: 0.0030,
        darkTint: 0.0060,
        inks:
        [
            .keyword: .purple,
            .type: .indigo,
            .alternateType: .blue,
            .member: .teal,
            .alternateMember: .cyan,
            .string: .red,
            .number: .indigo,
            .preprocessor: .brown,
            .link: .blue
        ],
        overrides: [.type: 9.40])
}
