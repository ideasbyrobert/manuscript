import Pigment

struct ContrastGoal: Sendable
{
    let target: ContrastRatio
    let chromaFactor: Double

    init(_ target: ContrastRatio, chromaFactor: Double)
    {
        self.target = target
        self.chromaFactor = chromaFactor
    }

    func reaching(_ replacement: ContrastRatio) -> ContrastGoal
    {
        ContrastGoal(replacement, chromaFactor: chromaFactor)
    }
}
