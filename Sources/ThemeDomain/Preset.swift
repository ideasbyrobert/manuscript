import AppleColors
import Pigment

public struct Preset: Sendable, Identifiable
{
    public let id: String
    public let title: String
    public let tintHue: Hue
    public let lightTint: Chroma
    public let darkTint: Chroma
    public let inks: [InkSlot: SystemColour]
    public let overrides: [InkSlot: ContrastRatio]

    public init(
        id: String,
        title: String,
        tintHue: Double,
        lightTint: Double,
        darkTint: Double,
        inks: [InkSlot: SystemColour],
        overrides: [InkSlot: ContrastRatio] = [:])
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

    public func ink(for slot: InkSlot) -> SystemColour
    {
        inks[slot] ?? .gray
    }

    public func goal(for slot: InkSlot) -> ContrastGoal
    {
        let base = ContrastGoals.bySlot[slot]
            ?? ContrastGoal(5.5, chromaFactor: 1)
        guard let override = overrides[slot] else
        {
            return base
        }
        return base.reaching(override)
    }

    public func tint(in appearance: Appearance) -> Chroma
    {
        appearance == .dark ? darkTint : lightTint
    }
}

extension Preset: CustomStringConvertible
{
    public var description: String
    {
        title
    }
}
