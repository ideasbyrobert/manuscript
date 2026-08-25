import Foundation

@testable import Posture

enum Run
{
    static func probe(
        _ executable: URL,
        _ probe: Probe,
        _ arguments: [String],
        within limit: Duration = .seconds(30)) async throws -> Report
    {
        let process = Process()
        process.executableURL = executable
        process.arguments = [probe.rawValue] + arguments
        let output = Pipe()
        let errors = Pipe()
        process.standardOutput = output
        process.standardError = errors
        try process.run()
        let stdout = Task.detached
        {
            output.fileHandleForReading.readDataToEndOfFile()
        }
        let stderr = Task.detached
        {
            errors.fileHandleForReading.readDataToEndOfFile()
        }
        let finished = (try? await within(limit)
        {
            await Task.detached { process.waitUntilExit() }.value
        }) != nil
        if !finished
        {
            process.terminate()
        }
        let text = String(decoding: await stdout.value, as: UTF8.self)
        let noise = String(decoding: await stderr.value, as: UTF8.self)
        let last = text.split(separator: "\n").last.map(String.init) ?? ""
        if let report = try? Report.decode(last)
        {
            var facts = report.facts
            facts["stderr"] = noise
            return Report(report.probe, verdicts: report.verdicts, facts: facts)
        }
        if !finished
        {
            return Report.hung(probe)
        }
        let status = Int(process.terminationStatus)
        let signalled = process.terminationReason == .uncaughtSignal
        return Report(
            probe,
            verdicts: [Verdict(
                "launch",
                .failed,
                code: status,
                message: signalled ? "signal" : "exit")],
            facts: ["stderr": noise, "stdout": text])
    }
}
