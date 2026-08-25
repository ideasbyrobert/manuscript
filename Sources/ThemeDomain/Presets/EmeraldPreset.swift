import AppleColors

extension Preset
{
    static let emerald = Preset(
        id: "emerald",
        title: "Emerald",
        tintHue: 148,
        lightTint: 0.0125,
        darkTint: 0.0170,
        inks:
        [
            .keyword: .green,
            .type: .brown,
            .alternateType: .orange,
            .member: .teal,
            .alternateMember: .green,
            .string: .purple,
            .number: .indigo,
            .preprocessor: .brown,
            .link: .blue
        ])
}
