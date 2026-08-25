import Foundation

struct Fixture
{
    let outside: URL
    let documents: URL?
    let argv: URL
    let scratch: URL

    init() throws
    {
        let tag = "manuscript-posture-" + UUID().uuidString
        let home = URL(fileURLWithPath: NSHomeDirectory())
        let directory = home.appendingPathComponent(tag, isDirectory: true)
        try FileManager.default.createDirectory(
            at: directory,
            withIntermediateDirectories: false)
        outside = directory.appendingPathComponent("x")
        try Data("outside the container\n".utf8).write(to: outside)
        let inDocuments = home
            .appendingPathComponent("Documents")
            .appendingPathComponent(tag + ".txt")
        if (try? Data("in documents\n".utf8).write(to: inDocuments)) != nil
        {
            documents = inDocuments
        }
        else
        {
            documents = nil
        }
        scratch = Products.root
            .appendingPathComponent(".build")
            .appendingPathComponent("posture")
            .appendingPathComponent(tag)
        try FileManager.default.createDirectory(
            at: scratch,
            withIntermediateDirectories: true)
        argv = scratch.appendingPathComponent("argv.txt")
        try Data("named on the command line\n".utf8).write(to: argv)
    }

    func remove()
    {
        try? FileManager.default.removeItem(
            at: outside.deletingLastPathComponent())
        if let documents
        {
            try? FileManager.default.removeItem(at: documents)
        }
        try? FileManager.default.removeItem(at: scratch)
    }
}
