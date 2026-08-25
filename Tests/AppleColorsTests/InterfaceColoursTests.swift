import Pigment
import Testing

@testable import AppleColors

@Suite("The colours the system reserves for itself")
struct InterfaceColoursTests
{
    @Test("the accent is Apple's blue, whatever the theme")
    func accentIsFixed()
    {
        #expect(InterfaceColours.accent.hexNotation == "#007aff")
    }

    @Test("selection differs by appearance")
    func selectionFollowsAppearance()
    {
        let light = InterfaceColours.selection(in: .light)
        let dark = InterfaceColours.selection(in: .dark)
        #expect(light.hexNotation != dark.hexNotation)
    }

    @Test("the dark selection is darker than the light one")
    func darkSelectionIsDarker()
    {
        let light = OKLCh(InterfaceColours.selection(in: .light))
        let dark = OKLCh(InterfaceColours.selection(in: .dark))
        #expect(dark.lightness < light.lightness)
    }

    @Test("both selections read as blue")
    func selectionsAreBlue()
    {
        for appearance in Appearance.allCases
        {
            let hue = OKLCh(InterfaceColours.selection(in: appearance)).hue
            #expect(hue.separation(from: Hue(degrees: 254)) < 30)
        }
    }
}
