import Foundation

struct SourceTree
{
    let root: URL

    init(root: URL)
    {
        self.root = root
    }

    init?(containing path: String)
    {
        var candidate = URL(fileURLWithPath: path).deletingLastPathComponent()
        while candidate.path != "/"
        {
            let manifest = candidate.appendingPathComponent("Package.swift")
            if FileManager.default.fileExists(atPath: manifest.path)
            {
                root = candidate
                return
            }
            candidate = candidate.deletingLastPathComponent()
        }
        return nil
    }

    var allFiles: [URL]
    {
        files(under: root)
    }

    var swiftFiles: [URL]
    {
        allFiles.filter { $0.pathExtension == "swift" }
    }

    func files(under directory: URL) -> [URL]
    {
        let walker = FileManager.default.enumerator(
            at: directory,
            includingPropertiesForKeys: [.isRegularFileKey])
        guard let walker else
        {
            return []
        }
        return walker
            .compactMap { $0 as? URL }
            .filter { Self.isPartOfThePackage($0) }
            .sorted { $0.path < $1.path }
    }

    func location(of file: URL) -> String
    {
        let base = root.resolvingSymlinksInPath().path + "/"
        let path = file.resolvingSymlinksInPath().path
        return path.replacingOccurrences(of: base, with: "")
    }

    func lines(of file: URL) -> [SourceLine]
    {
        let text = (try? String(contentsOf: file, encoding: .utf8)) ?? ""
        return text.components(separatedBy: "\n")
            .enumerated()
            .map { SourceLine(number: $0.offset + 1, text: $0.element) }
    }

    private static let hidden = [".git", ".build", ".swiftpm", ".DS_Store"]

    private static func isPartOfThePackage(_ url: URL) -> Bool
    {
        let regular = (try? url.resourceValues(forKeys: [.isRegularFileKey]))?
            .isRegularFile ?? false
        return regular && !url.pathComponents.contains { hidden.contains($0) }
    }
}
