import Testing

@testable import lint

@Suite("One type to a file")
struct DeclarationsTests
{
    @Test("two types in one file are refused")
    func twoTypesAreRefused() throws
    {
        let fixture = try PackageFixture()
        defer { fixture.remove() }
        try fixture.write(
            "Sources/A/Pair.swift",
            "struct One\n{\n}\n\nenum Two\n{\n}\n")
        try fixture.write("Tests/ATests/PairTests.swift", "")
        let types = fixture.violations.filter { $0.rule == "types" }
        #expect(types.count == 1)
        #expect(types.first?.detail == "2 types in one file")
    }

    @Test("a nested type and an extension do not count")
    func nestingAndExtensionsAreNotSeparateTypes() throws
    {
        let fixture = try PackageFixture()
        defer { fixture.remove() }
        try fixture.write(
            "Sources/A/Host.swift",
            "struct Host\n{\n    enum Inner\n    {\n    }\n}\n\n"
                + "extension Host\n{\n}\n")
        try fixture.write("Tests/ATests/HostTests.swift", "")
        #expect(fixture.violations.filter { $0.rule == "types" }.isEmpty)
    }

    @Test("a modifier does not hide a declaration")
    func modifiersAreSeenThrough()
    {
        #expect(Declarations.opens("package final class Door"))
        #expect(Declarations.opens("indirect enum Tree"))
        #expect(!Declarations.opens("extension Door"))
        #expect(!Declarations.opens("let structure = 1"))
    }
}
