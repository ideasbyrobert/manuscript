import Testing

@testable import Posture

@Suite("WebKit in the test host", .serialized)
struct PageTests
{
    @MainActor
    @Test("a rule list compiles in a temporary store")
    func rulesCompile() async
    {
        let verdicts = await Page.measure("about:blank", within: .seconds(20))
        let tmp = verdicts.first { $0.stage == "rules-tmp" }
        #expect(tmp?.answer == .permitted, "\(verdicts)")
    }

    @MainActor
    @Test("an unreachable host is refused, not hung")
    func unreachableHost() async
    {
        let verdicts = await Page.measure(
            "https://unreachable.invalid/",
            within: .seconds(20))
        let load = verdicts.first { $0.stage == "load" }
        #expect(load?.answer == .denied, "\(verdicts)")
        #expect(load?.code != nil)
    }
}
