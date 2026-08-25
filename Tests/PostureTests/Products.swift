import Foundation

enum Products
{
    static var root: URL
    {
        var url = URL(fileURLWithPath: #filePath)
        while url.path != "/"
        {
            url = url.deletingLastPathComponent()
            let manifest = url.appendingPathComponent("Package.swift").path
            if FileManager.default.fileExists(atPath: manifest)
            {
                return url
            }
        }
        return url
    }

    static var postureProbe: URL?
    {
        let build = root.appendingPathComponent(".build")
        let configurations =
        [
            "debug", "arm64-apple-macosx/debug", "x86_64-apple-macosx/debug"
        ]
        return configurations
            .map { build.appendingPathComponent($0 + "/posture-probe") }
            .first { FileManager.default.isExecutableFile(atPath: $0.path) }
    }
}
