import Foundation

struct Inspector
{
    static let measure = 80

    let tree: SourceTree

    var violations: [Violation]
    {
        tree.swiftFiles.flatMap { inspect($0) }
            + tree.allFiles.filter(Foreign.rejects).map(foreign)
    }

    private func inspect(_ file: URL) -> [Violation]
    {
        let location = tree.location(of: file)
        let lines = tree.lines(of: file)
        var found = lines.flatMap { judge($0, at: location) }
        let types = Declarations.count(in: lines)
        if types > 1
        {
            found.append(
                Violation(
                    location: location,
                    line: 1,
                    rule: "types",
                    detail: "\(types) types in one file"))
        }
        if Counterpart(tree: tree).isMissing(for: file)
        {
            found.append(
                Violation(
                    location: location,
                    line: 1,
                    rule: "mirror",
                    detail: "no mirrored test"))
        }
        return found
    }

    private func foreign(_ file: URL) -> Violation
    {
        Violation(
            location: tree.location(of: file),
            line: 1,
            rule: "foreign",
            detail: "not Swift")
    }

    private func judge(_ line: SourceLine, at location: String) -> [Violation]
    {
        var found: [Violation] = []
        if line.opensBraceOnSameLine
        {
            found.append(
                Violation(
                    location: location,
                    line: line.number,
                    rule: "braces",
                    detail: "opening brace shares its line"))
        }
        if line.carriesComment
        {
            found.append(
                Violation(
                    location: location,
                    line: line.number,
                    rule: "comments",
                    detail: "comment in code"))
        }
        if line.width > Self.measure
        {
            found.append(
                Violation(
                    location: location,
                    line: line.number,
                    rule: "width",
                    detail: "\(line.width) columns"))
        }
        if line.carriesPublic
        {
            found.append(
                Violation(
                    location: location,
                    line: line.number,
                    rule: "access",
                    detail: "public declaration"))
        }
        return found
    }
}
