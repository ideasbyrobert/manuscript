import Foundation
import Testing

@testable import Posture

@Suite("A security-scoped bookmark, in the test host")
struct BookmarkTests
{
    @Test("a file the host can reach mints, resolves, opens and reads")
    func fullChainInProcess() throws
    {
        let fixture = try Fixture()
        defer
        {
            fixture.remove()
        }
        let verdicts = Bookmark.measure(fixture.outside.path)
        #expect(verdicts.map(\.stage) == ["mint", "resolve", "access", "read"])
        #expect(verdicts.allSatisfy { $0.answer == .permitted }, "\(verdicts)")
    }

    @Test("a bookmark of a path that is not there is refused at the door")
    func missingIsRefused()
    {
        let verdicts = Bookmark.measure("/nowhere/manuscript/x")
        #expect(verdicts.count == 1)
        #expect(verdicts[0].stage == "mint")
        #expect(verdicts[0].answer == .denied)
        #expect(verdicts[0].code != nil)
    }
}
