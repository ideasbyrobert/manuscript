import Foundation
import Testing

@testable import Gate

@Suite("Only the newest load publishes", .serialized)
struct LatestTests
{
    @Test("a single load that nothing supersedes publishes")
    func lonePublishes() async throws
    {
        let latest = Latest<String, Int>()
        let published = try await latest.load("a") { 7 }
        #expect(published)
        #expect(await latest.published == [7])
        #expect(await latest.attempts == 1)
    }

    @Test("the later request finishes first; the earlier is refused")
    func laterFinishesFirst() async throws
    {
        let latest = Latest<String, String>()
        let pipeA = try NamedPipe()
        let pipeB = try NamedPipe()
        defer
        {
            pipeA.remove()
            pipeB.remove()
        }
        async let first: Bool = latest.load("a")
        {
            _ = try await pipeA.byte()
            return "a"
        }
        while await latest.attempts < 1
        {
            try await Task.sleep(for: .milliseconds(1))
        }
        async let second: Bool = latest.load("b")
        {
            _ = try await pipeB.byte()
            return "b"
        }
        while await latest.attempts < 2
        {
            try await Task.sleep(for: .milliseconds(1))
        }
        pipeB.feed()
        try await Task.sleep(for: .milliseconds(50))
        pipeA.feed()
        let (publishedFirst, publishedSecond) = try await (first, second)
        #expect(!publishedFirst)
        #expect(publishedSecond)
        #expect(await latest.published == ["b"])
    }

    @Test("closing refuses an attempt still in flight")
    func closingRefuses() async throws
    {
        let latest = Latest<String, Int>()
        let pipe = try NamedPipe()
        defer
        {
            pipe.remove()
        }
        async let running: Bool = latest.load("a")
        {
            _ = try await pipe.byte()
            return 1
        }
        while await latest.attempts < 1
        {
            try await Task.sleep(for: .milliseconds(1))
        }
        await latest.close()
        pipe.feed()
        let published = try await running
        #expect(!published)
        #expect(await latest.published.isEmpty)
    }
}
