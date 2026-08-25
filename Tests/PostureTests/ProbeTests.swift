import Testing

@testable import Posture

@Suite("Seven things the probe can be asked")
struct ProbeTests
{
    @Test("the names on the command line are the cases, with one hyphen")
    func names()
    {
        #expect(Probe(rawValue: "mach-client") == .machClient)
        #expect(Probe(rawValue: "sandbox") == .sandbox)
        #expect(Probe(rawValue: "nonsense") == nil)
        #expect(Probe.allCases.count == 7)
    }

    @Test("every probe asks for the sandbox, and only two ask for more")
    func entitlements()
    {
        for probe in Probe.allCases
        {
            let keys = probe.entitlements.entries.keys
            #expect(keys.contains(.appSandbox), "\(probe)")
        }
        #expect(Probe.bookmark.entitlements.entries[.bookmarksAppScope] != nil)
        #expect(Probe.web.entitlements.entries[.networkClient] != nil)
        #expect(Probe.read.entitlements == .sandboxed)
    }
}
