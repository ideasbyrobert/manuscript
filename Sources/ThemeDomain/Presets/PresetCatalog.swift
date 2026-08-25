public enum PresetCatalog
{
    public static let all: [Preset] =
    [
        .standard,
        .sakura,
        .ember,
        .sunrise,
        .midnight,
        .neonNoir,
        .cobalt,
        .coralReef,
        .emerald
    ]

    public static var identifiers: [String]
    {
        all.map(\.id)
    }

    public static func named(_ wanted: String) -> Preset?
    {
        all.first
        {
            $0.id == wanted || $0.title.lowercased() == wanted.lowercased()
        }
    }
}
