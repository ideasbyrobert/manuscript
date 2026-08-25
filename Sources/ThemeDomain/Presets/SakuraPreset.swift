import AppleColors

extension Preset
{
    static let sakura = Preset(
        id: "sakura",
        title: "Sakura",
        tintHue: 340,
        lightTint: 0.0130,
        darkTint: 0.0170,
        inks:
        [
            .keyword: .pink,
            .type: .purple,
            .alternateType: .indigo,
            .member: .red,
            .alternateMember: .brown,
            .string: .indigo,
            .number: .blue,
            .preprocessor: .brown,
            .link: .blue
        ])
}
