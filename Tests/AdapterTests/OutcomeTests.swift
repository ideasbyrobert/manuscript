import Testing

@testable import Adapter

@Suite("How a launch can end")
struct OutcomeTests
{
    @Test("a failure names the command that refused and why")
    func failureCarriesBoth()
    {
        let failed = Outcome.failed(command: "launch", message: "no program")
        #expect(failed == .failed(command: "launch", message: "no program"))
        #expect(failed != .failed(command: "attach", message: "no program"))
        #expect(failed != .completed)
        #expect(Outcome.ended != .completed)
    }
}
