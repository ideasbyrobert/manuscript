import Foundation

struct Counterpart
{
    let tree: SourceTree

    func isMissing(for file: URL) -> Bool
    {
        guard let target = target(of: file) else
        {
            return false
        }
        let name = file.deletingPathExtension().lastPathComponent
        guard name != "main" else
        {
            return false
        }
        let expected = name + "Tests.swift"
        let tests = tree.root
            .appendingPathComponent("Tests")
            .appendingPathComponent(target + "Tests")
        return !tree.files(under: tests).contains
        {
            $0.lastPathComponent == expected
        }
    }

    private func target(of file: URL) -> String?
    {
        let parts = tree.location(of: file).split(separator: "/")
        guard parts.count > 2, parts[0] == "Sources" else
        {
            return nil
        }
        return String(parts[1])
    }
}
