import Pigment
import Testing

@testable import AppleColors

@Suite("Reading the running system", .serialized)
struct AppKitSystemColoursTests
{
    private let live = AppKitSystemColours()

    @Test("every colour resolves to something inside the cube")
    func everyColourResolves()
    {
        for colour in SystemColour.allCases
        {
            for appearance in Appearance.allCases
            {
                let swatch = live.colour(colour, in: appearance)
                #expect(swatch.isWithinGamut, "\(colour) \(appearance)")
            }
        }
    }

    @Test("no two colours resolve to the same swatch")
    func swatchesAreDistinct()
    {
        let swatches = SystemColour.allCases.map
        {
            live.colour($0, in: .light).hexNotation
        }
        #expect(Set(swatches).count == swatches.count)
    }

    @Test("light and dark differ for every colour")
    func appearanceMatters()
    {
        for colour in SystemColour.allCases
        {
            let light = live.colour(colour, in: .light)
            let dark = live.colour(colour, in: .dark)
            #expect(light.hexNotation != dark.hexNotation, "\(colour)")
        }
    }

    @Test("the source satisfies the same contract as the recording")
    func interchangeable()
    {
        let sources: [any SystemColourSource] =
        [
            live,
            RecordedSystemColours.macOS27
        ]
        for source in sources
        {
            for colour in SystemColour.allCases
            {
                #expect(source.colour(colour, in: .light).isWithinGamut)
            }
        }
    }
}
