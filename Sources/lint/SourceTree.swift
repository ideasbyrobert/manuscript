import Foundation

struct SourceTree
{
    let root: URL

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

    var swiftFiles: [URL]
    {
        let walker = FileManager.default.enumerator(
            at: root,
            includingPropertiesForKeys: nil)
        guard let walker else
        {
            return []
        }
        return walker
            .compactMap { $0 as? URL }
            .filter { $0.pathExtension == "swift" }
            .filter { !$0.pathComponents.contains(".build") }
            .sorted { $0.path < $1.path }
    }

    func location(of file: URL) -> String
    {
        file.path.replacingOccurrences(of: root.path + "/", with: "")
    }

    func lines(of file: URL) -> [SourceLine]
    {
        let text = (try? String(contentsOf: file, encoding: .utf8)) ?? ""
        return text.components(separatedBy: "\n")
            .enumerated()
            .map { SourceLine(number: $0.offset + 1, text: $0.element) }
    }
}
