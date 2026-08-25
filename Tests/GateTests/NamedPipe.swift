import Darwin
import Foundation

struct NamedPipe
{
    let url: URL

    init() throws
    {
        url = FileManager.default.temporaryDirectory
            .appendingPathComponent("gate-fifo-" + UUID().uuidString)
        guard mkfifo(url.path, 0o600) == 0 else
        {
            throw Failure.notMade(errno)
        }
    }

    enum Failure: Error
    {
        case notMade(Int32)
    }

    func byte() async throws -> UInt8
    {
        try await withCheckedThrowingContinuation
        {
            continuation in
            Thread
            {
                let descriptor = open(url.path, O_RDONLY)
                guard descriptor >= 0 else
                {
                    continuation.resume(throwing: Failure.notMade(errno))
                    return
                }
                var value: UInt8 = 0
                _ = read(descriptor, &value, 1)
                close(descriptor)
                continuation.resume(returning: value)
            }
            .start()
        }
    }

    func feed()
    {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/sh")
        process.arguments = ["-c", "printf x > '\(url.path)'"]
        try? process.run()
    }

    func remove()
    {
        try? FileManager.default.removeItem(at: url)
    }
}
