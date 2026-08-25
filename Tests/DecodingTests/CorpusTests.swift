import Foundation
import Testing

@testable import Decoding

@Suite(
    "The decoder against libmagic, on the Emacs tree",
    .enabled(if:
        ProcessInfo.processInfo.environment["MANUSCRIPT_CORPUS"] == "1"))
struct CorpusTests
{
    private static let root =
        "/Users/robertkarapetyan/Developer/richard/upstream/emacs-mac"

    private func files() -> [String]
    {
        let base = URL(fileURLWithPath: Self.root)
        let walker = FileManager.default.enumerator(
            at: base,
            includingPropertiesForKeys: [.isRegularFileKey])
        var found: [String] = []
        while let item = walker?.nextObject() as? URL
        {
            let regular = try? item.resourceValues(
                forKeys: [.isRegularFileKey]).isRegularFile
            if regular == true
            {
                found.append(item.path)
            }
        }
        return found
    }

    private func encodings(_ paths: [String]) throws -> [String: String]
    {
        let list = FileManager.default.temporaryDirectory
            .appendingPathComponent("emacs-list-" + UUID().uuidString)
        try paths.joined(separator: "\n").write(
            to: list,
            atomically: true,
            encoding: .utf8)
        defer
        {
            try? FileManager.default.removeItem(at: list)
        }
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/file")
        process.arguments =
            ["--mime-encoding", "--separator", "\t", "-f", list.path]
        let pipe = Pipe()
        process.standardOutput = pipe
        try process.run()
        let handle = pipe.fileHandleForReading
        var data = Data()
        while case let chunk = handle.availableData, !chunk.isEmpty
        {
            data.append(chunk)
        }
        process.waitUntilExit()
        var verdicts: [String: String] = [:]
        for line in String(decoding: data, as: UTF8.self).split(separator: "\n")
        {
            guard let tab = line.range(of: "\t") else
            {
                continue
            }
            let path = String(line[..<tab.lowerBound])
            let encoding = String(line[tab.upperBound...])
                .trimmingCharacters(in: .whitespaces)
            verdicts[path] = encoding
        }
        return verdicts
    }

    @Test("no file libmagic calls binary is rendered as text")
    func noBinaryRenderedAsText() throws
    {
        let paths = files()
        #expect(paths.count > 1_000)
        let verdicts = try encodings(paths)
        var decoderText = 0
        var magicText = 0
        var empties = 0
        var betrayals: [String] = []
        var refusedButText: [String] = []
        for path in paths
        {
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: path))
            else
            {
                continue
            }
            let text = Decoding.text(of: data) != nil
            let magic = verdicts[path] ?? "binary"
            let magicBinary = magic == "binary"
            if text
            {
                decoderText += 1
            }
            if !magicBinary
            {
                magicText += 1
            }
            if text, magicBinary
            {
                if data.isEmpty
                {
                    empties += 1
                }
                else
                {
                    betrayals.append(path + " (" + magic + ")")
                }
            }
            if !text, !magicBinary
            {
                refusedButText.append(path + " (" + magic + ")")
            }
        }
        let report = "files \(paths.count), decoder-text \(decoderText),"
            + " magic-text \(magicText), empty-only \(empties),"
            + " betrayals \(betrayals.count),"
            + " refused-yet-text \(refusedButText.count)"
        print(report)
        for example in betrayals.prefix(10)
        {
            print("betrayal: " + example)
        }
        for example in refusedButText.prefix(10)
        {
            print("refused-yet-text: " + example)
        }
        #expect(betrayals.isEmpty, "\(betrayals.count) betrayals")
    }
}
