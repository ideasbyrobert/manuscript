import Testing

@testable import Pigment

@Suite("Blending two colours")
struct ColourBlendTests
{
    private func colour(_ notation: String) throws -> SRGB
    {
        try #require(SRGB(hexNotation: notation))
    }

    @Test("the ends of a blend are its arguments")
    func endpoints() throws
    {
        let one = try colour("#ff383c")
        let other = try colour("#0088ff")
        let start = ColourBlend.of(one, towards: other, by: 0)
        let finish = ColourBlend.of(one, towards: other, by: 1)
        #expect(start.hexNotation == one.hexNotation)
        #expect(finish.hexNotation == other.hexNotation)
    }

    @Test("a blend never escapes the cube")
    func staysInGamut() throws
    {
        let one = try colour("#cb30e0")
        let other = try colour("#34c759")
        for fraction in stride(from: 0.0, through: 1.0, by: 0.05)
        {
            let mixed = ColourBlend.of(one, towards: other, by: fraction)
            #expect(mixed.isWithinGamut)
        }
    }

    @Test("blending towards the ground moves lightness towards it")
    func movesTowardsGround() throws
    {
        let ink = try colour("#b00017")
        let ground = try colour("#fff7f2")
        let softened = ColourBlend.of(ink, towards: ground, by: 0.8)
        #expect(OKLCh(softened).lightness > OKLCh(ink).lightness)
        #expect(OKLCh(softened).lightness < OKLCh(ground).lightness)
    }
}
