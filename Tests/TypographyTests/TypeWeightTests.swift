import Testing

@testable import Typography

@Suite("Nine weights, lightest first")
struct TypeWeightTests
{
    @Test("the cases run from ultralight to black")
    func order()
    {
        #expect(TypeWeight.allCases.count == 9)
        #expect(TypeWeight.allCases.first == .ultralight)
        #expect(TypeWeight.allCases.last == .black)
        #expect(TypeWeight.allCases[3] == .regular)
    }

    @Test("a suffix is the case name with its first letter raised")
    func suffixes()
    {
        for weight in TypeWeight.allCases
        {
            let raw = weight.rawValue
            let raised = raw.prefix(1).uppercased() + raw.dropFirst()
            #expect(weight.suffix == raised, "\(weight)")
        }
    }
}
