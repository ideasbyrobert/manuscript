import AppleColors

extension Preset
{
    public static let neonNoir = Preset(
        id: "neon-noir",
        title: "Neon Noir",
        tintHue: 302,
        lightTint: 0.0130,
        darkTint: 0.0200,
        inks:
        [
            .keyword: .purple,
            .type: .indigo,
            .alternateType: .pink,
            .member: .blue,
            .alternateMember: .cyan,
            .string: .mint,
            .number: .cyan,
            .preprocessor: .pink,
            .link: .cyan
        ])
}
