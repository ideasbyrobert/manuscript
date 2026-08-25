import Testing

@testable import AppleColors
@testable import Specimen
@testable import Typography

@Suite("Weight steps one rung on a dark ground")
struct WeightPairingTests
{
    @Test("body and emphasis are each one rung heavier in the dark")
    func oneRungHeavier()
    {
        #expect(WeightPairing.body(on: .light) == .regular)
        #expect(WeightPairing.body(on: .dark) == .medium)
        #expect(WeightPairing.emphasis(on: .light) == .semibold)
        #expect(WeightPairing.emphasis(on: .dark) == .bold)
    }

    @Test("emphasis sits two rungs above body on either ground")
    func emphasisAboveBody()
    {
        for appearance in Appearance.allCases
        {
            let body = WeightPairing.body(on: appearance)
            let emphasis = WeightPairing.emphasis(on: appearance)
            let gap = WeightPairing.numeric(emphasis)
                - WeightPairing.numeric(body)
            #expect(gap == 200, "\(appearance)")
        }
    }

    @Test("the numeric scale is CSS's: hundreds from 100 to 900")
    func numericScale()
    {
        let numbers = TypeWeight.allCases.map(WeightPairing.numeric)
        #expect(numbers == Array(stride(from: 100, through: 900, by: 100)))
    }
}
