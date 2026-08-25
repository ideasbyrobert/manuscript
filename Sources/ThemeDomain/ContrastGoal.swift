import Pigment

public struct ContrastGoal: Sendable
{
    public let target: ContrastRatio
    public let chromaFactor: Double

    public init(_ target: ContrastRatio, chromaFactor: Double)
    {
        self.target = target
        self.chromaFactor = chromaFactor
    }

    public func reaching(_ replacement: ContrastRatio) -> ContrastGoal
    {
        ContrastGoal(replacement, chromaFactor: chromaFactor)
    }
}
