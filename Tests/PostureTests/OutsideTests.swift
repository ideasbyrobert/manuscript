import Darwin
import Foundation
import Testing

@testable import Posture

@Suite("open(2), and the number it gives back")
struct OutsideTests
{
    @Test("a readable file is permitted; a missing one fails with ENOENT")
    func readableAndMissing() throws
    {
        let fixture = try Fixture()
        defer
        {
            fixture.remove()
        }
        let found = Outside.measure([
            "here": fixture.outside.path,
            "gone": fixture.outside.path + ".missing"
        ])
        #expect(found.count == 2)
        #expect(found[0].stage == "gone")
        #expect(found[0].answer == .failed)
        #expect(found[0].errno == ENOENT)
        #expect(found[1].stage == "here")
        #expect(found[1].answer == .permitted)
    }

    @Test("a file with no permission bits is denied with EACCES")
    func noPermissionIsDenied() throws
    {
        let fixture = try Fixture()
        defer
        {
            fixture.remove()
        }
        chmod(fixture.outside.path, 0)
        defer
        {
            chmod(fixture.outside.path, 0o644)
        }
        let found = Outside.measure(["shut": fixture.outside.path])
        #expect(found[0].answer == .denied)
        #expect(found[0].errno == EACCES)
        #expect(found[0].message == "Permission denied")
    }
}
