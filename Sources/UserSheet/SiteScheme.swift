enum SiteScheme
{
    static let dark = declared("dark")
    static let light = declared("light")

    private static let attributes =
    [
        "data-theme", "data-color-mode", "data-bs-theme", "data-mode"
    ]

    private static func declared(_ scheme: String) -> [String]
    {
        ["." + scheme] + attributes.map { "[\($0)=\"\(scheme)\"]" }
    }
}
