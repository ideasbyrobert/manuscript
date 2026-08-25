import AppleColors

public enum MutedInks
{
    public static func boost(for colour: SystemColour) -> Double
    {
        colour == .brown ? 1.32 : 1.0
    }
}
