import AppleColors

enum MutedInks
{
    static func boost(for colour: SystemColour) -> Double
    {
        colour == .brown ? 1.32 : 1.0
    }
}
