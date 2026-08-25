import Foundation
import Testing

@testable import UserSheet

@Suite("How a site declares its own scheme")
struct SiteSchemeTests
{
    @Test("a class first, then the four attributes sites use")
    func darkSelectors()
    {
        #expect(SiteScheme.dark == [
            ".dark",
            "[data-theme=\"dark\"]",
            "[data-color-mode=\"dark\"]",
            "[data-bs-theme=\"dark\"]",
            "[data-mode=\"dark\"]"
        ])
    }

    @Test("light is the same shape with the other word")
    func lightMirrorsDark()
    {
        let expected = SiteScheme.dark.map
        {
            $0.replacingOccurrences(of: "dark", with: "light")
        }
        #expect(SiteScheme.light == expected)
        #expect(!SiteScheme.light.contains { $0.contains("dark") })
    }
}
