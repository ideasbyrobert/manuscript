import Pigment
import Testing

@testable import AppleColors

@Suite("The recorded swatches")
struct RecordedSystemColoursTests
{
    private let recorded = RecordedSystemColours.macOS27

    @Test("every colour is recorded in both appearances")
    func tableIsComplete()
    {
        for colour in SystemColour.allCases
        {
            for appearance in Appearance.allCases
            {
                let swatch = recorded.colour(colour, in: appearance)
                #expect(swatch.isWithinGamut, "\(colour) \(appearance)")
            }
        }
    }

    @Test("no two colours share a swatch within one appearance")
    func swatchesAreDistinct()
    {
        for appearance in Appearance.allCases
        {
            let swatches = SystemColour.allCases.map
            {
                recorded.colour($0, in: appearance).hexNotation
            }
            #expect(Set(swatches).count == swatches.count)
        }
    }

    @Test("dark swatches are lighter than their light counterparts")
    func darkSwatchesAreLifted()
    {
        for colour in SystemColour.allCases
        {
            let light = OKLCh(recorded.colour(colour, in: .light))
            let dark = OKLCh(recorded.colour(colour, in: .dark))
            #expect(dark.lightness >= light.lightness, "\(colour)")
        }
    }

    @Test("a colour keeps its hue across appearances")
    func hueSurvivesAppearance()
    {
        for colour in SystemColour.allCases where colour != .gray
        {
            let light = OKLCh(recorded.colour(colour, in: .light))
            let dark = OKLCh(recorded.colour(colour, in: .dark))
            #expect(light.hue.separation(from: dark.hue) < 10, "\(colour)")
        }
    }

    @Test("grey carries almost no chroma")
    func greyIsNeutral()
    {
        for appearance in Appearance.allCases
        {
            let grey = OKLCh(recorded.colour(.gray, in: appearance))
            #expect(grey.chroma.value < 0.02)
        }
    }
}
