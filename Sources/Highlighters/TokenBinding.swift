import ThemeDomain

package struct TokenBinding: Sendable
{
    package let selectors: [String]
    package let role: PaletteName
    package let emphasis: Emphasis

    package init(
        _ selectors: [String],
        _ role: PaletteName,
        _ emphasis: Emphasis = .none)
    {
        self.selectors = selectors
        self.role = role
        self.emphasis = emphasis
    }
}
