import Testing

@testable import AppleColors
@testable import Pigment
@testable import ThemeDomain

@Suite("Inks are solved from the source they are given")
struct PaletteResolverTests
{
    private struct Grey: SystemColourSource
    {
        func colour(_ colour: SystemColour, in appearance: Appearance) -> SRGB
        {
            SRGB(red: 0.5, green: 0.5, blue: 0.5)
        }
    }

    @Test("a grey source yields grey inks; the recorded one, colour")
    func sourceIsHonoured()
    {
        let grey = PaletteResolver(
            preset: .ember,
            appearance: .light,
            systemColours: Grey()).resolve()
        let recorded = PaletteResolver(
            preset: .ember,
            appearance: .light).resolve()
        #expect(OKLCh(grey[.keyword]).chroma.value < 0.01)
        #expect(OKLCh(recorded[.keyword]).chroma.value > 0.1)
    }

    @Test("the hue of an ink is the system colour's, never the preset's")
    func hueIsKept()
    {
        for appearance in Appearance.allCases
        {
            let palette = PaletteResolver(
                preset: .ember,
                appearance: appearance).resolve()
            let asked = RecordedSystemColours.macOS27
                .colour(.purple, in: appearance)
            let found = OKLCh(palette[.string]).hue
            #expect(found.separation(from: OKLCh(asked).hue) < 3)
        }
    }

    @Test("an override moves an ink to the readability it names")
    func overrideIsReached()
    {
        let palette = PaletteResolver(
            preset: .standard,
            appearance: .light).resolve()
        let type = Readability.between(
            palette[.type],
            palette[.background]).magnitude
        let member = Readability.between(
            palette[.member],
            palette[.background]).magnitude
        #expect(abs(type - 87) < 2)
        #expect(abs(member - 72) < 2)
    }

    @Test("surfaces step away from the ground, towards the light")
    func surfacesStep()
    {
        let light = PaletteResolver(
            preset: .cobalt,
            appearance: .light).resolve()
        let dark = PaletteResolver(
            preset: .cobalt,
            appearance: .dark).resolve()
        #expect(
            OKLCh(light[.raisedBackground]).lightness
                < OKLCh(light[.background]).lightness)
        #expect(
            OKLCh(dark[.raisedBackground]).lightness
                > OKLCh(dark[.background]).lightness)
    }
}
