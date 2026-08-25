import Testing

@testable import Posture

@Suite("Mach and XPC in the test host", .serialized)
struct RendezvousTests
{
    @Test("an anonymous endpoint carries a reply to itself")
    func anonymousRoundTrips()
    {
        let verdicts = Rendezvous.measure(bundleID: nil)
        let anonymous = verdicts.first { $0.stage == "anonymous" }
        #expect(anonymous?.answer == .permitted, "\(verdicts)")
    }

    @Test("a global name the process does not own is refused")
    func foreignGlobalNameRefused()
    {
        let verdicts = Rendezvous.measure(bundleID: nil)
        let global = verdicts.first { $0.stage == "global" }
        #expect(global?.answer == .denied, "\(verdicts)")
    }

    @Test("without a bundle there is no self stage")
    func noBundleNoSelf()
    {
        let stages = Rendezvous.measure(bundleID: nil).map(\.stage)
        #expect(!stages.contains("self"))
        #expect(stages == ["global", "anonymous"])
    }
}
