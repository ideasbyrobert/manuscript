import AppleColors

extension Preset
{
    public static let coralReef = Preset(
        id: "coral-reef",
        title: "Coral Reef",
        tintHue: 192,
        lightTint: 0.0125,
        darkTint: 0.0175,
        inks:
        [
            .keyword: .teal,
            .type: .cyan,
            .alternateType: .blue,
            .member: .green,
            .alternateMember: .mint,
            .string: .pink,
            .number: .orange,
            .preprocessor: .purple,
            .link: .blue
        ])
}
