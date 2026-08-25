import Foundation
import Testing

@testable import Adapter

@Suite("The handshake, in whichever order the adapter answers")
struct LaunchTests
{
    private let launch = Configuration(
        clientID: "test",
        adapterID: "mock",
        start: .launch(["program": "/foo/bar"]),
        breakpoints: ["/src.swift": [11]])

    private let attach = Configuration(
        clientID: "test",
        adapterID: "mock",
        start: .attach(["processId": 1234]),
        breakpoints: ["/src.swift": [11]])

    private func run(
        _ configuration: Configuration,
        on link: Scripted) -> Task<Outcome, Never>
    {
        Task
        {
            await Launch.run(on: link, configuration)
        }
    }

    private func outcome(
        of task: Task<Outcome, Never>) async throws -> Outcome
    {
        try await within(.seconds(5)) { await task.value }
    }

    @Test("initialize goes first and alone")
    func initializeFirst() async throws
    {
        let link = Scripted()
        _ = run(launch, on: link)
        #expect(await link.sentCount(reaches: 1))
        try await Task.sleep(for: .milliseconds(30))
        #expect(await link.commands == ["initialize"])
        _ = await link.end()
    }

    @Test("the start command follows the initialize answer, with its words")
    func startFollowsInitialize() async throws
    {
        let link = Scripted()
        _ = run(attach, on: link)
        #expect(await link.sentCount(reaches: 1))
        await link.answer(1)
        #expect(await link.sentCount(reaches: 2))
        #expect(await link.commands == ["initialize", "attach"])
        #expect(await link.sent[1].arguments?["processId"]?.int == 1234)
        _ = await link.end()
    }

    @Test("breakpoints wait for the start answer and initialized, either way")
    func waitsForBoth() async throws
    {
        for initializedFirst in [true, false]
        {
            let link = Scripted()
            _ = run(launch, on: link)
            #expect(await link.sentCount(reaches: 1))
            await link.answer(1)
            #expect(await link.sentCount(reaches: 2))
            if initializedFirst
            {
                await link.emit("initialized")
                try await Task.sleep(for: .milliseconds(30))
                #expect(await link.commands.count == 2)
                await link.answer(2)
            }
            else
            {
                await link.answer(2)
                try await Task.sleep(for: .milliseconds(30))
                #expect(await link.commands.count == 2)
                await link.emit("initialized")
            }
            #expect(await link.sentCount(reaches: 3))
            #expect(await link.commands.last == "setBreakpoints")
            _ = await link.end()
        }
    }

    @Test("the whole chain, in order, completing only on the last answer")
    func wholeChain() async throws
    {
        let link = Scripted()
        let task = run(launch, on: link)
        #expect(await link.sentCount(reaches: 1))
        await link.answer(1)
        #expect(await link.sentCount(reaches: 2))
        await link.answer(2)
        await link.emit("initialized")
        #expect(await link.sentCount(reaches: 3))
        await link.answer(3)
        #expect(await link.sentCount(reaches: 4))
        await link.answer(4)
        #expect(await link.sentCount(reaches: 5))
        try await Task.sleep(for: .milliseconds(30))
        #expect(!task.isCancelled)
        await link.answer(5)
        #expect(try await outcome(of: task) == .completed)
        #expect(await link.commands == [
            "initialize", "launch", "setBreakpoints",
            "setExceptionBreakpoints", "configurationDone"
        ])
    }

    @Test("without breakpoints the chain skips setBreakpoints")
    func noBreakpoints() async throws
    {
        let bare = Configuration(
            clientID: "test",
            adapterID: "mock",
            start: .launch(["program": "/x"]))
        let link = Scripted()
        let task = run(bare, on: link)
        #expect(await link.sentCount(reaches: 1))
        await link.answer(1)
        #expect(await link.sentCount(reaches: 2))
        await link.answer(2)
        await link.emit("initialized")
        #expect(await link.sentCount(reaches: 3))
        await link.answer(3)
        #expect(await link.sentCount(reaches: 4))
        await link.answer(4)
        #expect(try await outcome(of: task) == .completed)
        #expect(await link.commands == [
            "initialize", "launch", "setExceptionBreakpoints",
            "configurationDone"
        ])
    }

    @Test("one setBreakpoints per source, sources in order")
    func manySources() async throws
    {
        let many = Configuration(
            clientID: "test",
            adapterID: "mock",
            start: .launch(["program": "/x"]),
            breakpoints: ["/proj/B.swift": [22], "/proj/A.swift": [11]])
        let link = Scripted()
        _ = run(many, on: link)
        #expect(await link.sentCount(reaches: 1))
        await link.answer(1)
        #expect(await link.sentCount(reaches: 2))
        await link.answer(2)
        await link.emit("initialized")
        #expect(await link.sentCount(reaches: 3))
        await link.answer(3)
        #expect(await link.sentCount(reaches: 4))
        let paths = await link.sent.dropFirst(2)
            .compactMap { $0.arguments?["source"]?["path"]?.string }
        #expect(paths == ["/proj/A.swift", "/proj/B.swift"])
        _ = await link.end()
    }

    @Test("a refusal at initialize ends it there, with the adapter's words")
    func initializeRefused() async throws
    {
        let link = Scripted()
        let task = run(launch, on: link)
        #expect(await link.sentCount(reaches: 1))
        await link.answer(1, success: false, message: "adapter unavailable")
        let found = try await outcome(of: task)
        #expect(found == .failed(
            command: "initialize",
            message: "adapter unavailable"))
        await link.emit("initialized")
        try await Task.sleep(for: .milliseconds(30))
        #expect(await link.commands == ["initialize"])
    }

    @Test("a refusal without words is still a refusal")
    func refusedWithoutWords() async throws
    {
        let link = Scripted()
        let task = run(launch, on: link)
        #expect(await link.sentCount(reaches: 1))
        await link.answer(1, success: false)
        let found = try await outcome(of: task)
        let refused = Outcome.failed(
            command: "initialize",
            message: "(no message)")
        #expect(found == refused)
    }

    @Test("a refusal at launch after initialized skips the configuration")
    func launchRefusedAfterInitialized() async throws
    {
        let link = Scripted()
        let task = run(launch, on: link)
        #expect(await link.sentCount(reaches: 1))
        await link.answer(1)
        #expect(await link.sentCount(reaches: 2))
        await link.emit("initialized")
        await link.answer(2, success: false, message: "could not start")
        let found = try await outcome(of: task)
        #expect(found == .failed(command: "launch", message: "could not start"))
        #expect(!(await link.commands).contains("setBreakpoints"))
        #expect(!(await link.commands).contains("configurationDone"))
    }

    @Test("a link that ends mid-handshake ends the launch")
    func endedMidway() async throws
    {
        let link = Scripted()
        let task = run(launch, on: link)
        #expect(await link.sentCount(reaches: 1))
        await link.answer(1)
        #expect(await link.sentCount(reaches: 2))
        _ = await link.end()
        #expect(try await outcome(of: task) == .ended)
    }

    @Test("against the mock, initialized before or after the start answer")
    func mockEitherOrder() async throws
    {
        let executable = try #require(Products.mockAdapter)
        for order in ["before-start", "after-start"]
        {
            let session = Session(
                executable: executable,
                environment: ["MOCK_INITIALIZED": order, "MOCK_START": "slow"])
            try await session.start()
            let found = try await within(.seconds(10))
            {
                await Launch.run(on: session, launch)
            }
            #expect(found == .completed, "\(order)")
            let stopped = try await within(.seconds(5))
            {
                await session.once("stopped")
            }
            let reason = stopped?.body?["reason"]?.string
            #expect(reason == "breakpoint", "\(order)")
            #expect(await session.end() == .exited)
        }
    }
}
