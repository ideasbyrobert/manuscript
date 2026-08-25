import Foundation
import Testing

@testable import Posture

@Suite("A minimal application around a binary")
struct HousingTests
{
    @Test("Foundation reads the identifier we wrote")
    func identifierIsRead() throws
    {
        let fixture = try Fixture()
        defer
        {
            fixture.remove()
        }
        let housing = Housing(identifier: "manuscript.housed", executable: "p")
        let bundle = try housing.assemble(
            around: fixture.argv,
            in: fixture.scratch)
        #expect(Bundle(url: bundle)?.bundleIdentifier == "manuscript.housed")
        #expect(Bundle(url: bundle)?.executableURL?.lastPathComponent == "p")
    }

    @Test("the executable and its helpers sit where LaunchServices looks")
    func layout() throws
    {
        let fixture = try Fixture()
        defer
        {
            fixture.remove()
        }
        let housing = Housing(identifier: "manuscript.housed", executable: "p")
        let bundle = try housing.assemble(
            around: fixture.argv,
            helpers: [fixture.outside],
            in: fixture.scratch)
        let macOS = bundle.appendingPathComponent("Contents/MacOS")
        let names = try FileManager.default
            .contentsOfDirectory(atPath: macOS.path)
        #expect(Set(names) == ["p", "x"])
        #expect(housing.infoPlist.contains("<key>LSUIElement</key>"))
    }
}
