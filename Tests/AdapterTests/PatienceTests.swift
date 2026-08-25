import Testing

@testable import Adapter

@Suite("How long an ending may take")
struct PatienceTests
{
    @Test("the bound is the answer, the grace, and two chances to die")
    func bound()
    {
        let patience = Patience(
            answer: .milliseconds(200),
            grace: .milliseconds(100),
            kill: .seconds(1))
        #expect(patience.bound == .milliseconds(2_300))
    }

    @Test("the defaults end a session in under five seconds")
    func defaults()
    {
        #expect(Patience().bound < .seconds(5))
        #expect(Patience().answer == .seconds(2))
    }
}
