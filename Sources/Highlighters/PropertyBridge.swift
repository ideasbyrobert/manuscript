import ThemeDomain

package struct PropertyBridge: Sendable
{
    package let property: String
    package let role: PaletteName

    package init(_ property: String, _ role: PaletteName)
    {
        self.property = property
        self.role = role
    }
}
