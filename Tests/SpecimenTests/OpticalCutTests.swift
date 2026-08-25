import Testing

@testable import Specimen
@testable import Typography

@Suite("New York's four cuts, chosen by size")
struct OpticalCutTests
{
    @Test("the cut changes at 21, 29 and 43 points")
    func boundaries()
    {
        #expect(OpticalCut.serif(atPoints: 20.9) == .newYorkSmall)
        #expect(OpticalCut.serif(atPoints: 21) == .newYorkMedium)
        #expect(OpticalCut.serif(atPoints: 28.9) == .newYorkMedium)
        #expect(OpticalCut.serif(atPoints: 29) == .newYorkLarge)
        #expect(OpticalCut.serif(atPoints: 42.9) == .newYorkLarge)
        #expect(OpticalCut.serif(atPoints: 43) == .newYorkExtraLarge)
        #expect(OpticalCut.serif(atPoints: 200) == .newYorkExtraLarge)
    }

    @Test("a larger size never asks for a smaller cut")
    func monotone()
    {
        let order: [Typeface] =
        [
            .newYorkSmall, .newYorkMedium, .newYorkLarge, .newYorkExtraLarge
        ]
        var last = 0
        for tenths in stride(from: 60, through: 800, by: 1)
        {
            let cut = OpticalCut.serif(atPoints: Double(tenths) / 10)
            let rank = order.firstIndex(of: cut)!
            #expect(rank >= last)
            last = rank
        }
    }
}
