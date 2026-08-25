import Foundation
import Testing

@testable import Adapter

@Suite("A child spoken to over a pipe")
struct SessionTests
{
    private let quick = Patience(
        answer: .milliseconds(200),
        grace: .milliseconds(100),
        kill: .seconds(1))

    private func mock(
        _ environment: [String: String] = [:],
        patience: Patience = Patience()) async throws -> Session
    {
        let executable = try #require(Products.mockAdapter)
        let session = Session(
            executable: executable,
            environment: environment,
            patience: patience)
        try await session.start()
        return session
    }

    @Test("a frame the pipe split is parsed once, wherever it split")
    func splitFrames() async throws
    {
        let session = try await mock(["MOCK_SPLIT_FRAMES": "1"])
        let response = try await within(.seconds(5))
        {
            try await session.request("evaluate", ["expression": "a"])
        }
        #expect(response.body?["result"]?.string == "value(a)")
        #expect(await session.end() == .exited)
    }

    @Test("two requests in flight each see their own body")
    func correlation() async throws
    {
        let session = try await mock()
        let (one, two) = try await within(.seconds(5))
        {
            async let first = session.request("evaluate", ["expression": "a"])
            async let second = session.request("evaluate", ["expression": "b"])
            return try await (first, second)
        }
        #expect(one.body?["result"]?.string == "value(a)")
        #expect(two.body?["result"]?.string == "value(b)")
        #expect(one.requestSeq != two.requestSeq)
        #expect(await session.end() == .exited)
    }

    @Test("an event that arrived before anyone waited is still claimed once")
    func unclaimedEventIsKept() async throws
    {
        let session = try await mock()
        _ = try await session.request("initialize")
        _ = try await session.request("launch")
        _ = try await session.request("configurationDone")
        try await Task.sleep(for: .milliseconds(100))
        let first = try await within(.seconds(5))
        {
            await session.once("stopped")
        }
        #expect(first?.body?["reason"]?.string == "breakpoint")
        _ = try await session.request("next")
        let second = try await within(.seconds(5))
        {
            await session.once("stopped")
        }
        #expect(second?.body?["reason"]?.string == "step")
        #expect(await session.end() == .exited)
    }

    @Test("ending an adapter that leaves on request is quick and clean")
    func endsCleanly() async throws
    {
        let session = try await mock(patience: quick)
        _ = try await session.request("initialize")
        let started = ContinuousClock.now
        let reason = await session.end()
        #expect(reason == .exited)
        #expect(started.duration(to: .now) < .seconds(1))
        #expect(await !session.isRunning)
    }

    @Test("an adapter that acknowledges and lingers is gone within bound")
    func lingerer() async throws
    {
        let session = try await mock(
            ["MOCK_DISCONNECT": "linger"],
            patience: quick)
        let started = ContinuousClock.now
        let reason = await session.end()
        #expect(reason == .lingered)
        #expect(started.duration(to: .now) < quick.bound)
        #expect(await !session.isRunning)
    }

    @Test("an adapter that never answers is gone within bound")
    func silent() async throws
    {
        let session = try await mock(
            ["MOCK_DISCONNECT": "ignore"],
            patience: quick)
        let started = ContinuousClock.now
        let reason = await session.end()
        #expect(reason == .silent)
        #expect(started.duration(to: .now) < quick.bound)
        #expect(await !session.isRunning)
    }

    @Test("an adapter that ignores termination is killed within bound")
    func ignoresTermination() async throws
    {
        let session = try await mock(
            ["MOCK_DISCONNECT": "ignore-term"],
            patience: quick)
        let started = ContinuousClock.now
        let reason = await session.end()
        #expect(reason == .lingered)
        #expect(started.duration(to: .now) < quick.bound)
        #expect(started.duration(to: .now) > quick.kill)
        #expect(await !session.isRunning)
    }

    @Test("a child that closes its end ends every wait")
    func endOfFile() async throws
    {
        let session = Session(executable: URL(fileURLWithPath: "/usr/bin/true"))
        try await session.start()
        let waited = Task
        {
            await session.once("never")
        }
        await #expect(throws: AdapterError.ended)
        {
            _ = try await within(.seconds(5))
            {
                try await session.request("initialize")
            }
        }
        let event = try await within(.seconds(5)) { await waited.value }
        #expect(event == nil)
        #expect(await session.isEnded)
    }

    @Test("a request before start is refused, not written into nothing")
    func beforeStart() async throws
    {
        let session = Session(executable: URL(fileURLWithPath: "/usr/bin/true"))
        await #expect(throws: AdapterError.notStarted)
        {
            _ = try await session.request("initialize")
        }
    }
}
