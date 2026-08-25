import Foundation
import Posture

let given = Array(CommandLine.arguments.dropFirst())
guard let first = given.first, let probe = Probe(rawValue: first) else
{
    FileHandle.standardError.write(
        Data("posture-probe: expected a probe name\n".utf8))
    exit(2)
}
DispatchQueue.global().asyncAfter(deadline: .now() + 120)
{
    print(Report.hung(probe).json)
    exit(0)
}
let report = await probe.measure(Array(given.dropFirst()))
print(report.json)
exit(0)
