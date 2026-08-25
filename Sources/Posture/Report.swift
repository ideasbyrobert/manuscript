import Foundation

package struct Report: Codable, Hashable, Sendable
{
    package let probe: Probe
    package let verdicts: [Verdict]
    package let facts: [String: String]

    package init(
        _ probe: Probe,
        verdicts: [Verdict],
        facts: [String: String] = [:])
    {
        self.probe = probe
        self.verdicts = verdicts
        self.facts = facts
    }

    package subscript(stage: String) -> Verdict?
    {
        verdicts.first { $0.stage == stage }
    }

    package var json: String
    {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try! encoder.encode(self)
        return String(decoding: data, as: UTF8.self)
    }

    package static func decode(_ text: String) throws -> Report
    {
        try JSONDecoder().decode(Report.self, from: Data(text.utf8))
    }

    package static func hung(_ probe: Probe) -> Report
    {
        Report(probe, verdicts: [Verdict("watchdog", .hung)])
    }
}
