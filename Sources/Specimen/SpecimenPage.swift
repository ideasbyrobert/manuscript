import AppleColors
import ThemeDomain
import Typography

package enum SpecimenPage
{
    package static let serifStack =
        "ui-serif, \"New York\", Georgia, serif"
    package static let monoStack =
        "ui-monospace, \"SF Mono\", Menlo, monospace"
    package static let interfaceStack =
        "system-ui, -apple-system, \"SF Pro\", sans-serif"

    package static func escaped(_ text: String) -> String
    {
        text
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
    }

    package static func variables(for theme: Theme) -> String
    {
        PaletteName.allCases
            .map { "  --\($0.rawValue): \(theme.palette.notation($0));" }
            .joined(separator: "\n")
    }

    package static func roleClasses() -> String
    {
        PaletteName.allCases
            .map { ".r-\($0.rawValue) { color: var(--\($0.rawValue)); }" }
            .joined(separator: "\n")
    }

    package static func codeMarkup(on appearance: Appearance) -> String
    {
        SpecimenText.code
            .map
            {
                let pieces = SpecimenMarkup.tokens(in: $0).map
                {
                    token -> String in
                    let body = escaped(token.text)
                    guard let role = token.role else
                    {
                        return body
                    }
                    let weight = role == .keyword
                        ? WeightPairing.numeric(
                            WeightPairing.emphasis(on: appearance))
                        : WeightPairing.numeric(
                            WeightPairing.body(on: appearance))
                    return "<span class=\"r-\(role.rawValue)\" "
                        + "style=\"font-weight:\(weight)\">\(body)</span>"
                }
                return "<span class=\"line\">"
                    + pieces.joined()
                    + "</span>"
            }
            .joined(separator: "\n")
    }

    package static func paragraphs(_ blocks: [String]) -> String
    {
        blocks
            .map { "<p>\(escaped($0))</p>" }
            .joined(separator: "\n")
    }
}
