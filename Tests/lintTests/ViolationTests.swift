import Testing

@testable import lint

@Suite("How a violation is reported")
struct ViolationTests
{
    @Test("the place is padded so the rules line up")
    func placeIsPadded()
    {
        let violation = Violation(
            location: "Sources/A/B.swift",
            line: 7,
            rule: "width",
            detail: "81 columns")
        let report = violation.report
        #expect(report.hasPrefix("Sources/A/B.swift:7"))
        #expect(report.hasSuffix("width  81 columns"))
        #expect(report.count == 44 + 1 + "width  81 columns".count)
    }
}
