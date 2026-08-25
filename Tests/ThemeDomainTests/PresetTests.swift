import Testing

@testable import AppleColors
@testable import Pigment
@testable import ThemeDomain

@Suite("What a preset declares")
struct PresetTests
{
    @Test("a preset fills every ink slot")
    func slotsAreFilled()
    {
        for slot in InkSlot.allCases
        {
            #expect(Preset.ember.inks[slot] != nil, "\(slot)")
        }
    }

    @Test("the tint is stronger in the dark than in the light")
    func darkGroundCarriesMoreTint()
    {
        #expect(Preset.ember.tint(in: .dark) > Preset.ember.tint(in: .light))
    }

    @Test("a slot without an override keeps its standard goal")
    func goalsDefaultToStandard()
    {
        let standard = ContrastGoals.bySlot[.keyword]!.target
        #expect(Preset.ember.goal(for: .keyword).target == standard)
    }

    @Test("an override replaces the target but not the chroma factor")
    func overridesAreSurgical()
    {
        let overridden = Preset(
            id: "trial",
            title: "Trial",
            tintHue: 0,
            lightTint: 0.01,
            darkTint: 0.01,
            inks: Preset.ember.inks,
            overrides: [.type: 87])
        let standard = ContrastGoals.bySlot[.type]!
        #expect(overridden.goal(for: .type).target == 87)
        #expect(
            overridden.goal(for: .type).chromaFactor == standard.chromaFactor)
    }

    @Test("a preset prints as its title")
    func printsAsTitle()
    {
        #expect("\(Preset.ember)" == "Ember")
    }
}
