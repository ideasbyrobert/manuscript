import Cascade
import ThemeDomain

package enum AuthorSheet
{
    package static let floor = ["manuscript-floor", "manuscript-floor-2"]

    package static func sheet(for pair: ThemePair) -> StyleSheet
    {
        StyleSheet(UserStyleSheet.blocks(for: pair)).authorOrigin(floor: floor)
    }

    package static func text(for pair: ThemePair) -> String
    {
        sheet(for: pair).text + "\n"
    }
}
