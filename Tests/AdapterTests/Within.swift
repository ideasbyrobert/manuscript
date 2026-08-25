struct Timeout: Error
{
}

func within<T: Sendable>(
    _ limit: Duration,
    _ body: @escaping @Sendable () async throws -> T) async throws -> T
{
    try await withThrowingTaskGroup(of: T.self)
    {
        group in
        group.addTask
        {
            try await body()
        }
        group.addTask
        {
            try await Task.sleep(for: limit)
            throw Timeout()
        }
        let first = try await group.next()!
        group.cancelAll()
        return first
    }
}
