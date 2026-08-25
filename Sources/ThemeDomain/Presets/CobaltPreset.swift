import AppleColors

extension Preset
{
    public static let cobalt = Preset(
        id: "cobalt",
        title: "Cobalt",
        tintHue: 288,
        lightTint: 0.0110,
        darkTint: 0.0190,
        inks:
        [
            .keyword: .blue,
            .type: .indigo,
            .alternateType: .purple,
            .member: .cyan,
            .alternateMember: .teal,
            .string: .orange,
            .number: .yellow,
            .preprocessor: .pink,
            .link: .blue
        ])
}
