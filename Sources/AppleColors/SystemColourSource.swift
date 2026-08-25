import Pigment

public protocol SystemColourSource: Sendable
{
    func colour(_ colour: SystemColour, in appearance: Appearance) -> SRGB
}
