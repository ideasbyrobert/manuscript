import AppleColors

extension Preset
{
    static let ember = Preset(
        id: "ember",
        title: "Ember",
        tintHue: 52,
        lightTint: 0.0120,
        darkTint: 0.0150,
        inks:
        [
            .keyword: .red,
            .type: .orange,
            .alternateType: .red,
            .member: .brown,
            .alternateMember: .orange,
            .string: .purple,
            .number: .blue,
            .preprocessor: .orange,
            .link: .blue
        ])
}
