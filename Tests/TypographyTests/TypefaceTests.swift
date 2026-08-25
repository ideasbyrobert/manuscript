import Testing

@testable import Typography

@Suite("The faces the specimen may name")
struct TypefaceTests
{
    @Test("only SF Mono is fixed pitch")
    func monoAlone()
    {
        #expect(Typeface.allCases.filter(\.isFixedPitch) == [.sfMono])
    }

    @Test("only SF Compact Display ships without italics")
    func compactDisplayIsUpright()
    {
        let upright = Typeface.allCases.filter { !$0.carriesItalics }
        #expect(upright == [.sfCompactDisplay])
    }

    @Test("stems are unique and carry no spaces")
    func stems()
    {
        let stems = Typeface.allCases.map(\.stem)
        #expect(Set(stems).count == stems.count)
        #expect(stems.allSatisfy { !$0.contains(" ") })
        #expect(Typeface.newYorkExtraLarge.stem == "NewYorkExtraLarge")
    }

    @Test("New York and SF Mono carry six weights; SF Pro all nine")
    func weights()
    {
        #expect(Typeface.newYorkSmall.weights.count == 6)
        #expect(!Typeface.newYorkSmall.weights.contains(.ultralight))
        #expect(Typeface.sfMono.weights.first == .light)
        #expect(!Typeface.sfMono.weights.contains(.black))
        #expect(Typeface.sfPro.weights == TypeWeight.allCases)
    }
}
