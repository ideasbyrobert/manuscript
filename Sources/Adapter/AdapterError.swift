package enum AdapterError: Error, Hashable, Sendable
{
    case ended
    case notStarted
    case corruptStream
}
