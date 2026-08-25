import Foundation
import Testing

@testable import Revision

@Suite("A read held between two revisions")
struct BracketTests
{
    @Test("a read nothing touched is whole")
    func untouchedIsWhole() throws
    {
        let scratch = try Scratch()
        defer
        {
            scratch.remove()
        }
        let url = try scratch.file("calm", holding: "steady\n")
        let bracket = try Bracket.read(at: url, maximumBytes: 1_024)
        #expect(!bracket.isTorn)
        #expect(bracket.bytes == Data("steady\n".utf8))
        #expect(bracket.after == bracket.before)
    }

    @Test("a second process appending mid-read tears it")
    func appendedByAnotherProcess() throws
    {
        let scratch = try Scratch()
        defer
        {
            scratch.remove()
        }
        let url = try scratch.file("shared", holding: "before\n")
        var calls = 0
        let bracket = try Bracket.read(at: url, maximumBytes: 1_024)
        {
            calls += 1
            guard calls == 1 else
            {
                return
            }
            try Scratch.shell("printf x >> '\(url.path)'")
        }
        #expect(bracket.isTorn)
        #expect(bracket.after?.size == bracket.before.size + 1)
        #expect(bracket.after?.inode == bracket.before.inode)
    }

    @Test("an atomic save mid-read leaves a different file under the name")
    func replacedByAnotherProcess() throws
    {
        let scratch = try Scratch()
        defer
        {
            scratch.remove()
        }
        let url = try scratch.file("saved", holding: "old\n")
        let staging = scratch.directory.appendingPathComponent("staging")
        var calls = 0
        let bracket = try Bracket.read(at: url, maximumBytes: 1_024)
        {
            calls += 1
            guard calls == 1 else
            {
                return
            }
            try Scratch.shell(
                "printf new > '\(staging.path)'"
                    + " && mv -f '\(staging.path)' '\(url.path)'")
        }
        #expect(bracket.isTorn)
        #expect(bracket.after?.inode != bracket.before.inode)
    }

    @Test("a file removed mid-read is torn, not a crash")
    func removedMidRead() throws
    {
        let scratch = try Scratch()
        defer
        {
            scratch.remove()
        }
        let url = try scratch.file("gone", holding: "here\n")
        var calls = 0
        let bracket = try Bracket.read(at: url, maximumBytes: 1_024)
        {
            calls += 1
            guard calls == 1 else
            {
                return
            }
            try FileManager.default.removeItem(at: url)
        }
        #expect(bracket.isTorn)
        #expect(bracket.after == nil)
        #expect(bracket.bytes == Data("here\n".utf8))
    }
}
