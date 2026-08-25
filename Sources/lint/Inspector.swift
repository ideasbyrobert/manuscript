import Foundation

struct Inspector
{
    static let measure = 80

    let tree: SourceTree

    var violations: [Violation]
    {
        tree.swiftFiles.flatMap { inspect($0) }
    }

    private func inspect(_ file: URL) -> [Violation]
    {
        let location = tree.location(of: file)
        return tree.lines(of: file).flatMap { line in
            judge(line, at: location)
        }
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
        return found
    }
}
