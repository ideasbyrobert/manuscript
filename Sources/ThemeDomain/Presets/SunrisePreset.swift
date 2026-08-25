import AppleColors

extension Preset
{
    static let sunrise = Preset(
        id: "sunrise",
        title: "Sunrise",
        tintHue: 88,
        lightTint: 0.0135,
        darkTint: 0.0160,
        inks:
        [
            .keyword: .yellow,
            .type: .orange,
            .alternateType: .brown,
            .member: .green,
            .alternateMember: .orange,
            .string: .teal,
            .number: .blue,
            .preprocessor: .brown,
            .link: .blue
        ])
}
