package actor Latest<Subject: Hashable & Sendable, Value: Sendable>
{
    private var fence = Fence<Subject>()
    package private(set) var attempts = 0
    package private(set) var published: [Value] = []

    package init()
    {
    }

    @discardableResult
    package func load(
        _ subject: Subject,
        _ work: @Sendable () async throws -> Value) async throws -> Bool
    {
        let ticket = fence.begin(for: subject)
        attempts += 1
        let value = try await work()
        guard fence.accepts(ticket) else
        {
            return false
        }
        published.append(value)
        return true
    }

    package func close()
    {
        fence.invalidate()
    }
}
