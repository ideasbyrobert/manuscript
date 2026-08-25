package enum RevisionError: Error, Hashable, Sendable
{
    case unreadable(Int32)
    case invalidMaximum
    case tooLarge(minimumObserved: Int)
}
