import Testing

@testable import lint

@Suite("The standard, measured")
struct InspectorTests
{
    @Test("a package that meets every rule reports nothing")
    func aCleanPackageIsSilent() throws
    {
        let fixture = try PackageFixture()
        defer { fixture.remove() }
        try fixture.write("Sources/A/Clean.swift", "struct Clean\n{\n}\n")
        try fixture.write("Tests/ATests/CleanTests.swift", "")
        #expect(fixture.violations.isEmpty)
    }
}
