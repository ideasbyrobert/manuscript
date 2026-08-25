import AppleColors

extension Preset
{
    public static let midnight = Preset(
        id: "midnight",
        title: "Midnight",
        tintHue: 240,
        lightTint: 0.0200,
        darkTint: 0.0245,
        inks:
        [
            .keyword: .blue,
            .type: .indigo,
            .alternateType: .purple,
            .member: .teal,
            .alternateMember: .mint,
            .string: .pink,
            .number: .cyan,
            .preprocessor: .indigo,
            .link: .cyan
        ])
}
