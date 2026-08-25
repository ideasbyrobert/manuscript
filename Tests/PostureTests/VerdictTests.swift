import Foundation
import Testing

@testable import Posture

@Suite("One stage's answer from the kernel")
struct VerdictTests
{
    @Test("a verdict survives JSON with its numbers intact")
    func roundTrip() throws
    {
        let verdict = Verdict(
            "open",
            .denied,
            errno: 1,
            code: nil,
            domain: nil,
            message: "Operation not permitted")
        let data = try JSONEncoder().encode(verdict)
        let back = try JSONDecoder().decode(Verdict.self, from: data)
        #expect(back == verdict)
        #expect(back.errno == 1)
        #expect(back.code == nil)
    }

    @Test("the answers are spelled as plain words on the wire")
    func spelling()
    {
        #expect(Verdict.Answer.permitted.rawValue == "permitted")
        #expect(Verdict.Answer.denied.rawValue == "denied")
        #expect(Verdict.Answer.failed.rawValue == "failed")
        #expect(Verdict.Answer.hung.rawValue == "hung")
    }
}
