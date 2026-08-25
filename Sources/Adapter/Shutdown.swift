package enum Shutdown
{
    package enum Reason: Hashable, Sendable
    {
        case exited
        case silent
        case lingered
    }

    package enum Action: Hashable, Sendable
    {
        case wait
        case finish(Reason)
    }

    package static func action(
        answered: Bool,
        running: Bool,
        elapsed: Duration,
        patience: Patience) -> Action
    {
        guard running else
        {
            return .finish(.exited)
        }
        guard answered else
        {
            return elapsed < patience.answer ? .wait : .finish(.silent)
        }
        return elapsed < patience.answer + patience.grace
            ? .wait
            : .finish(.lingered)
    }
}
