import Foundation
import Testing

@testable import Adapter

@Suite("lldb-dap, through the seam written for another debugger", .serialized)
struct DebuggerTests
{
    private static func tool(_ name: String) throws -> URL
    {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
        process.arguments = ["--find", name]
        let pipe = Pipe()
        process.standardOutput = pipe
        try process.run()
        process.waitUntilExit()
        let found = String(
            decoding: pipe.fileHandleForReading.readDataToEndOfFile(),
            as: UTF8.self)
        let path = found.trimmingCharacters(in: .whitespacesAndNewlines)
        #expect(!path.isEmpty, "xcrun found no \(name)")
        return URL(fileURLWithPath: path)
    }

    private static func compiled() throws -> URL
    {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent("DebuggerTests-" + UUID().uuidString)
        try FileManager.default.createDirectory(
            at: directory,
            withIntermediateDirectories: false)
        let source = directory.appendingPathComponent("hello.swift")
        try Data("print(\"hello from the debuggee\")\n".utf8).write(to: source)
        let binary = directory.appendingPathComponent("hello")
        let process = Process()
        process.executableURL = try tool("swiftc")
        process.arguments = ["-g", "-o", binary.path, source.path]
        try process.run()
        process.waitUntilExit()
        #expect(process.terminationStatus == 0)
        return binary
    }

    @Test("a program compiled with -g is launched, runs, prints and exits")
    func launchesAndRuns() async throws
    {
        let program = try Self.compiled()
        defer
        {
            try? FileManager.default.removeItem(
                at: program.deletingLastPathComponent())
        }
        let session = Session(executable: try Self.tool("lldb-dap"))
        try await session.start()
        let configuration = Configuration(
            clientID: "manuscript",
            adapterID: "lldb",
            start: .launch(
            [
                "program": .string(program.path),
                "cwd": .string(program.deletingLastPathComponent().path),
                "stopOnEntry": false
            ]))
        let outcome = try await within(.seconds(90))
        {
            await Launch.run(on: session, configuration)
        }
        #expect(outcome == .completed)
        let (printed, exited) = try await within(.seconds(60))
        {
            () async -> (String, Message?) in
            var printed = ""
            while let output = await session.once("output")
            {
                printed += output.body?["output"]?.string ?? ""
                if printed.contains("hello from the debuggee")
                {
                    break
                }
            }
            return (printed, await session.once("exited"))
        }
        #expect(printed.contains("hello from the debuggee"))
        #expect(exited?.body?["exitCode"]?.int == 0)
        let terminated = try await within(.seconds(10))
        {
            await session.once("terminated")
        }
        #expect(terminated != nil)
        let started = ContinuousClock.now
        #expect(await session.end() == .exited)
        #expect(started.duration(to: .now) < Patience().bound)
    }
}
