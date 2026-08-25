import Testing

@testable import Posture

@Suite("What a probe prints")
struct ReportTests
{
    @Test("a report is one line of JSON that decodes back to itself")
    func oneLine() throws
    {
        let denied = Verdict("y", .denied, errno: 1)
        let verdicts = [Verdict("x", .permitted), denied]
        let report = Report(.read, verdicts: verdicts, facts: ["HOME": "/x"])
        #expect(!report.json.contains("\n"))
        #expect(try Report.decode(report.json) == report)
    }

    @Test("a stage is found by name, and a missing one is nil")
    func byStage()
    {
        let report = Report(.read, verdicts: [Verdict("y", .denied, errno: 1)])
        #expect(report["y"]?.errno == 1)
        #expect(report["z"] == nil)
    }

    @Test("a hung report says so under the watchdog's name")
    func hung()
    {
        let report = Report.hung(.web)
        #expect(report.probe == .web)
        #expect(report["watchdog"]?.answer == .hung)
    }
}
