package protocol Link: Sendable
{
    func request(_ command: String, _ arguments: JSON?) async throws -> Message
    func once(_ event: String) async -> Message?
    func end() async -> Shutdown.Reason
}
