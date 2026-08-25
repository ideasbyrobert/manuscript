import Testing

@testable import lint

@Suite("Only Swift enters the package")
struct ForeignTests
{
    @Test("a Markdown file is refused")
    func markdownIsRefused() throws
    {
        let fixture = try PackageFixture()
        defer { fixture.remove() }
        try fixture.write("README.md", "# no\n")
        let foreign = fixture.violations.filter { $0.rule == "foreign" }
        #expect(foreign.count == 1)
        #expect(foreign.first?.location == "README.md")
    }

    @Test("the two files a package cannot do without are admitted")
    func gitignoreAndResolvedAreAdmitted() throws
    {
        let fixture = try PackageFixture()
        defer { fixture.remove() }
        try fixture.write(".gitignore", ".build/\n")
        try fixture.write("Package.resolved", "{}\n")
        #expect(fixture.violations.filter { $0.rule == "foreign" }.isEmpty)
    }

    @Test("Finder's litter is not the package's")
    func dsStoreIsNotSeen() throws
    {
        let fixture = try PackageFixture()
        defer { fixture.remove() }
        try fixture.write(".DS_Store", "")
        try fixture.write("Sources/.DS_Store", "")
        #expect(fixture.violations.filter { $0.rule == "foreign" }.isEmpty)
    }
}
