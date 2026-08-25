import Foundation

guard let tree = SourceTree(containing: #filePath) else
{
    FileHandle.standardError.write(Data("lint: no package found\n".utf8))
    exit(2)
}

let violations = Inspector(tree: tree).violations

for violation in violations
{
    print(violation.report)
}

if !violations.isEmpty
{
    let plural = violations.count == 1 ? "" : "s"
    print("")
    print("\(violations.count) violation\(plural)")
}

exit(violations.isEmpty ? 0 : 1)
