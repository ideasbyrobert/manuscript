import ThemeDomain

package struct SpecimenToken: Sendable, Equatable
{
    package let text: String
    package let role: PaletteName?

    package init(_ text: String, role: PaletteName?)
    {
        self.text = text
        self.role = role
    }
}
