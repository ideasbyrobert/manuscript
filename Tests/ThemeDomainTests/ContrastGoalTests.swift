import Testing

@testable import Pigment
@testable import ThemeDomain

@Suite("A goal is a readability and a share of chroma")
struct ContrastGoalTests
{
    @Test("reaching a new target keeps the chroma factor")
    func reachingKeepsChroma()
    {
        let goal = ContrastGoal(Readability(71), chromaFactor: 0.95)
        let raised = goal.reaching(Readability(87))
        #expect(raised.target == Readability(87))
        #expect(raised.chromaFactor == 0.95)
        #expect(goal.target == Readability(71))
    }
}
