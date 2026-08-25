package enum Outcome: Hashable, Sendable
{
    case completed
    case failed(command: String, message: String)
    case ended
}
