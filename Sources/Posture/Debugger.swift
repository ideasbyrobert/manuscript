import Adapter
import Foundation

package enum Debugger
{
    package static func measure(
        adapter: String,
        program: String) async -> [Verdict]
    {
        let session = Session(
            executable: URL(fileURLWithPath: adapter),
            patience: Patience(
                answer: .seconds(2),
                grace: .seconds(1),
                kill: .seconds(2)))
        do
        {
            try await session.start()
        }
        catch let error as NSError
        {
            return [Verdict(
                "spawn",
                .denied,
                code: error.code,
                domain: error.domain,
                message: error.localizedDescription)]
        }
        let directory = (program as NSString).deletingLastPathComponent
        let configuration = Configuration(
            clientID: "posture",
            adapterID: "lldb",
            start: .launch(
            [
                "program": .string(program),
                "cwd": .string(directory),
                "stopOnEntry": false
            ]))
        let outcome = await Launch.run(on: session, configuration)
        var verdicts = [Verdict("spawn", .permitted)]
        switch outcome
        {
        case .completed:
            verdicts.append(Verdict("launch", .permitted))
        case .failed(let command, let message):
            verdicts.append(Verdict(
                "launch",
                .denied,
                message: "\(command): \(message)"))
        case .ended:
            verdicts.append(Verdict("launch", .failed, message: "ended"))
        }
        let reason = await session.end()
        verdicts.append(Verdict("end", .permitted, message: "\(reason)"))
        return verdicts
    }
}
