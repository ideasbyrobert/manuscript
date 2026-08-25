import Testing

@testable import lint

@Suite("A source without its test")
struct CounterpartTests
{
    @Test("a source with no mirrored test is an orphan")
    func anOrphanIsReported() throws
    {
        let fixture = try PackageFixture()
        defer { fixture.remove() }
        try fixture.write("Sources/A/Lonely.swift", "struct Lonely\n{\n}\n")
        let mirror = fixture.violations.filter { $0.rule == "mirror" }
        #expect(mirror.count == 1)
        #expect(mirror.first?.location == "Sources/A/Lonely.swift")
    }

    @Test("a test anywhere under the mirrored target satisfies it")
    func aNestedTestCounts() throws
    {
        let fixture = try PackageFixture()
        defer { fixture.remove() }
        try fixture.write("Sources/A/Deep/Thing.swift", "struct Thing\n{\n}\n")
        try fixture.write("Tests/ATests/Elsewhere/ThingTests.swift", "")
        #expect(fixture.violations.filter { $0.rule == "mirror" }.isEmpty)
    }

    @Test("an entry point is never asked for a mirror")
    func mainIsExempt() throws
    {
        let fixture = try PackageFixture()
        defer { fixture.remove() }
        try fixture.write("Sources/tool/main.swift", "print(1)\n")
        #expect(fixture.violations.filter { $0.rule == "mirror" }.isEmpty)
    }

    @Test("a test file is not itself asked for a mirror")
    func testsAreNotSources() throws
    {
        let fixture = try PackageFixture()
        defer { fixture.remove() }
        try fixture.write("Tests/ATests/OnlyTests.swift", "")
        #expect(fixture.violations.filter { $0.rule == "mirror" }.isEmpty)
    }
}
