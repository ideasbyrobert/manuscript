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

    @Test("a public declaration is refused")
    func publicIsRefused() throws
    {
        let fixture = try PackageFixture()
        defer { fixture.remove() }
        try fixture.write(
            "Sources/A/Open.swift",
            "public struct Open\n{\n    open var x = 1\n}\n")
        try fixture.write("Tests/ATests/OpenTests.swift", "")
        let access = fixture.violations.filter { $0.rule == "access" }
        #expect(access.map { $0.line } == [1, 3])
    }

    @Test("the word public inside a string is not a declaration")
    func aQuotedPublicIsNotADeclaration() throws
    {
        let fixture = try PackageFixture()
        defer { fixture.remove() }
        try fixture.write(
            "Sources/A/Quote.swift",
            "struct Quote\n{\n    let word = \"public \"\n}\n")
        try fixture.write("Tests/ATests/QuoteTests.swift", "")
        #expect(fixture.violations.filter { $0.rule == "access" }.isEmpty)
    }

    @Test("every rule the standard names has a name here")
    func everyRuleIsNamed() throws
    {
        let fixture = try PackageFixture()
        defer { fixture.remove() }
        try fixture.write(
            "Sources/A/Bad.swift",
            "public struct Bad {\n"
                + "    let x = 1 // note\n"
                + "    let long = \"" + String(repeating: "x", count: 80)
                + "\"\n}\nenum Worse\n{\n}\n")
        try fixture.write("README.md", "")
        let rules = Set(fixture.violations.map { $0.rule })
        #expect(rules == [
            "braces", "comments", "width", "access", "types", "mirror",
            "foreign"])
    }
}
