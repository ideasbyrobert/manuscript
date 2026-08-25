import Testing

@testable import Adapter

@Suite("When to stop waiting for a child")
struct ShutdownTests
{
    private let patience = Patience(
        answer: .seconds(2),
        grace: .milliseconds(750),
        kill: .seconds(1))

    private func action(
        answered: Bool,
        running: Bool,
        after elapsed: Duration) -> Shutdown.Action
    {
        Shutdown.action(
            answered: answered,
            running: running,
            elapsed: elapsed,
            patience: patience)
    }

    @Test("a child that has left needs nothing, answered or not")
    func exited()
    {
        #expect(action(answered: false, running: false, after: .zero)
            == .finish(.exited))
        #expect(action(answered: true, running: false, after: .seconds(9))
            == .finish(.exited))
    }

    @Test("an unanswered child is waited for until the answer deadline")
    func silent()
    {
        let almost = patience.answer - .nanoseconds(1)
        #expect(action(answered: false, running: true, after: almost) == .wait)
        #expect(action(answered: false, running: true, after: patience.answer)
            == .finish(.silent))
    }

    @Test("an answered child gets the grace on top, then no more")
    func lingered()
    {
        let limit = patience.answer + patience.grace
        #expect(action(answered: true, running: true, after: patience.answer)
            == .wait)
        #expect(action(answered: true, running: true, after: limit)
            == .finish(.lingered))
    }
}
