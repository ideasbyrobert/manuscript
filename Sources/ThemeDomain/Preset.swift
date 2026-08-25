import AppleColors
import Pigment

struct Preset: Sendable, Identifiable
{
    let id: String
    package let title: String
    let tintHue: Hue
    let lightTint: Chroma
    let darkTint: Chroma
    let inks: [InkSlot: SystemColour]
    let overrides: [InkSlot: Readability]

    init(
        id: String,
        title: String,
        tintHue: Double,
        lightTint: Double,
        darkTint: Double,
        inks: [InkSlot: SystemColour],
        overrides: [InkSlot: Readability] = [:])
    {
        precondition(
            Set(InkSlot.allCases).subtracting(inks.keys).isEmpty,
            "\(id) leaves an ink slot unfilled")
        self.id = id
        self.title = title
        self.tintHue = Hue(degrees: tintHue)
        self.lightTint = Chroma(lightTint)
        self.darkTint = Chroma(darkTint)
        self.inks = inks
        self.overrides = overrides
    }

    func ink(for slot: InkSlot) -> SystemColour
    {
        inks[slot] ?? .gray
    }

    func goal(for slot: InkSlot) -> ContrastGoal
    {
        let base = ContrastGoals.bySlot[slot]
            ?? ContrastGoal(75, chromaFactor: 1)
        guard let override = overrides[slot] else
        {
            return base
        }
        return base.reaching(override)
    }

    func tint(in appearance: Appearance) -> Chroma
    {
        appearance == .dark ? darkTint : lightTint
    }
}

extension Preset: CustomStringConvertible
{
    var description: String
    {
        title
    }
}
