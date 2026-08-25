import Pigment

public struct RecordedSystemColours: SystemColourSource
{
    public static let macOS27 = RecordedSystemColours(
        light:
        [
            .red: "#FF383C",
            .orange: "#FF8D28",
            .yellow: "#FFCC00",
            .green: "#34C759",
            .mint: "#00C8B3",
            .teal: "#00C3D0",
            .cyan: "#00C0E8",
            .blue: "#0088FF",
            .indigo: "#6155F5",
            .purple: "#CB30E0",
            .pink: "#FF2D55",
            .brown: "#AC7F5E",
            .gray: "#8E8E93"
        ],
        dark:
        [
            .red: "#FF4245",
            .orange: "#FF9230",
            .yellow: "#FFD600",
            .green: "#30D158",
            .mint: "#00DAC3",
            .teal: "#00D2E0",
            .cyan: "#3CD3FE",
            .blue: "#0091FF",
            .indigo: "#6D7CFF",
            .purple: "#DB34F2",
            .pink: "#FF375F",
            .brown: "#B78A66",
            .gray: "#98989D"
        ])

    private let swatches: [Appearance: [SystemColour: SRGB]]

    public init(
        light: [SystemColour: String],
        dark: [SystemColour: String])
    {
        swatches =
        [
            .light: Self.parsed(light),
            .dark: Self.parsed(dark)
        ]
    }

    public func colour(
        _ colour: SystemColour,
        in appearance: Appearance) -> SRGB
    {
        swatches[appearance]![colour]!
    }

    private static func parsed(
        _ notations: [SystemColour: String]) -> [SystemColour: SRGB]
    {
        var parsed: [SystemColour: SRGB] = [:]
        for colour in SystemColour.allCases
        {
            guard let notation = notations[colour],
                let swatch = SRGB(hexNotation: notation) else
            {
                preconditionFailure("no swatch recorded for \(colour)")
            }
            parsed[colour] = swatch
        }
        return parsed
    }
}
