import Foundation
import Testing

@testable import lint

@Suite("Finding the package around a file")
struct SourceTreeTests
{
    @Test("the root is where the manifest is, however deep the file")
    func rootIsFoundByWalkingUp() throws
    {
        let fixture = try PackageFixture()
        defer { fixture.remove() }
        try fixture.write("Sources/A/B/C.swift", "")
        let deep = fixture.root.appendingPathComponent("Sources/A/B/C.swift")
        let found = SourceTree(containing: deep.path)
        #expect(found?.root.path == fixture.root.path)
    }

    @Test("build products are not source")
    func buildDirectoriesAreSkipped() throws
    {
        let fixture = try PackageFixture()
        defer { fixture.remove() }
        try fixture.write(".build/Generated.swift", "")
        try fixture.write("Sources/A/Real.swift", "")
        let names = fixture.tree.swiftFiles.map { $0.lastPathComponent }
        #expect(names == ["Package.swift", "Real.swift"])
    }

    @Test("a location is stated relative to the root")
    func locationsAreRelative() throws
    {
        let fixture = try PackageFixture()
        defer { fixture.remove() }
        let file = fixture.root.appendingPathComponent("Sources/A/X.swift")
        #expect(fixture.tree.location(of: file) == "Sources/A/X.swift")
    }
}
