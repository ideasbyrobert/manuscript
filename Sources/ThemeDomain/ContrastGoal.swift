import Pigment

struct ContrastGoal: Sendable
{
    let target: Readability
    let chromaFactor: Double

    init(_ target: Readability, chromaFactor: Double)
    {
        self.target = target
        self.chromaFactor = chromaFactor
    }

    func reaching(_ replacement: Readability) -> ContrastGoal
    {
        ContrastGoal(replacement, chromaFactor: chromaFactor)
    }
}
