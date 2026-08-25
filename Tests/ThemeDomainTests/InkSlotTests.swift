import Testing

@testable import ThemeDomain

@Suite("The slots a preset fills")
struct InkSlotTests
{
    @Test("there are nine, matching Xcode's syntax rows")
    func nineSlots()
    {
        #expect(InkSlot.allCases.count == 9)
    }

    @Test("each slot has a distinct name")
    func namesAreUnique()
    {
        let names = InkSlot.allCases.map(\.rawValue)
        #expect(Set(names).count == names.count)
    }

    @Test("every slot pairs a primary with its alternate")
    func alternatesPair()
    {
        let names = Set(InkSlot.allCases.map(\.rawValue))
        #expect(names.contains("type"))
        #expect(names.contains("alternateType"))
        #expect(names.contains("member"))
        #expect(names.contains("alternateMember"))
    }
}
