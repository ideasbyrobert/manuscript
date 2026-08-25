import Darwin
import Foundation

struct Scratch
{
    let directory: URL

    init() throws
    {
        directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(
                "RevisionTests-" + UUID().uuidString,
                isDirectory: true)
        try FileManager.default.createDirectory(
            at: directory,
            withIntermediateDirectories: false)
    }

    func file(_ name: String, holding text: String) throws -> URL
    {
        let url = directory.appendingPathComponent(name)
        try Data(text.utf8).write(to: url)
        return url
    }

    func remove()
    {
        try? FileManager.default.removeItem(at: directory)
    }

    static func rewrite(_ url: URL, holding text: String)
    {
        let descriptor = open(url.path, O_WRONLY | O_TRUNC)
        _ = text.withCString { write(descriptor, $0, text.utf8.count) }
        close(descriptor)
    }

    static func pin(_ url: URL, to date: Date) throws
    {
        try FileManager.default.setAttributes(
            [.modificationDate: date],
            ofItemAtPath: url.path)
    }

    static func shell(_ command: String) throws
    {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/sh")
        process.arguments = ["-c", command]
        try process.run()
        process.waitUntilExit()
    }
}
