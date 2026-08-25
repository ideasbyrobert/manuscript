import Foundation
import Testing

@testable import Posture

@Suite("lldb-dap in the test host", .serialized)
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
        let path = String(
            decoding: pipe.fileHandleForReading.readDataToEndOfFile(),
            as: UTF8.self)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return URL(fileURLWithPath: path)
    }

    private static func compiled(_ fixture: Fixture) throws -> URL
    {
        let source = fixture.scratch.appendingPathComponent("h.swift")
        try Data("print(\"hello from the debuggee\")\n".utf8).write(to: source)
        let binary = fixture.scratch.appendingPathComponent("h")
        let process = Process()
        process.executableURL = try tool("swiftc")
        process.arguments = ["-g", "-o", binary.path, source.path]
        try process.run()
        process.waitUntilExit()
        return binary
    }

    @Test("a program compiled with -g is launched and the child ends")
    func launchesInProcess() async throws
    {
        let fixture = try Fixture()
        defer
        {
            fixture.remove()
        }
        let program = try Self.compiled(fixture)
        let adapter = try Self.tool("lldb-dap")
        let verdicts = await Debugger.measure(
            adapter: adapter.path,
            program: program.path)
        #expect(verdicts.first { $0.stage == "spawn" }?.answer == .permitted)
        let launch = verdicts.first { $0.stage == "launch" }
        #expect(launch?.answer == .permitted, "\(verdicts)")
        #expect(verdicts.first { $0.stage == "end" } != nil)
    }
}
