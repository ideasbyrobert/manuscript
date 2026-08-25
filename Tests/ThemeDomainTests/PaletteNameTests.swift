import Testing

@testable import ThemeDomain

@Suite("The roles a theme assigns")
struct PaletteNameTests
{
    @Test("no role is declared twice")
    func namesAreUnique()
    {
        let names = PaletteName.allCases.map(\.rawValue)
        #expect(Set(names).count == names.count)
    }

    @Test("every ink slot has a role of the same name")
    func slotsHaveRoles()
    {
        let roles = Set(PaletteName.allCases.map(\.rawValue))
        for slot in InkSlot.allCases
        {
            #expect(roles.contains(slot.rawValue), "\(slot)")
        }
    }

    @Test("the ground and the text that sits on it both exist")
    func essentialRolesExist()
    {
        let roles = Set(PaletteName.allCases.map(\.rawValue))
        #expect(roles.contains("background"))
        #expect(roles.contains("text"))
        #expect(roles.contains("cursor"))
        #expect(roles.contains("selection"))
    }

    @Test("a role name survives being written and read back")
    func namesRoundTrip()
    {
        for name in PaletteName.allCases
        {
            #expect(PaletteName(rawValue: name.rawValue) == name)
        }
    }
}
