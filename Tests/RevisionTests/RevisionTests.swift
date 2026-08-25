import Darwin
import Foundation
import Testing

@testable import Revision

@Suite("A change to a file that its writer cannot hide")
struct RevisionTests
{
    @Test("an in-place rewrite that restores the date still changes it")
    func restoredDateStillChanges() throws
    {
        let scratch = try Scratch()
        defer
        {
            scratch.remove()
        }
        let url = try scratch.file("s.txt", holding: "alpha sentinel\n")
        let fixed = Date(timeIntervalSince1970: 1_700_000_000)
        try Scratch.pin(url, to: fixed)
        let first = try Revision.of(url)
        Scratch.rewrite(url, holding: "bravo sentinel\n")
        try Scratch.pin(url, to: fixed)
        let second = try Revision.of(url)
        #expect(second.inode == first.inode)
        #expect(second.size == first.size)
        #expect(second.modified == first.modified)
        #expect(second.changed != first.changed)
        #expect(second != first)
        #expect(first.digest == nil)
    }

    @Test("ten thousand immediate rewrites never share a revision")
    func tenThousandRewrites() throws
    {
        let scratch = try Scratch()
        defer
        {
            scratch.remove()
        }
        let url = try scratch.file("r.txt", holding: "round\n")
        var last = try Revision.of(url)
        var shared = 0
        for round in 0 ..< 10_000
        {
            Scratch.rewrite(url, holding: "round \(round)\n")
            let now = try Revision.of(url)
            if now == last
            {
                shared += 1
            }
            last = now
        }
        #expect(shared == 0)
    }

    @Test("where the volume keeps no change time, the digest tells")
    func digestTells() throws
    {
        let scratch = try Scratch()
        defer
        {
            scratch.remove()
        }
        let url = try scratch.file("d.txt", holding: "one\n")
        let volume = Volume.other("exfat")
        let first = try Revision.of(url, on: volume)
        Scratch.rewrite(url, holding: "two\n")
        let second = try Revision.of(url, on: volume)
        Scratch.rewrite(url, holding: "two\n")
        let third = try Revision.of(url, on: volume)
        #expect(first.digest != nil)
        #expect(first.digest != second.digest)
        #expect(second.digest == third.digest)
    }

    @Test("a file that is not there answers with the kernel's errno")
    func missingFile() throws
    {
        let scratch = try Scratch()
        defer
        {
            scratch.remove()
        }
        let missing = scratch.directory.appendingPathComponent("no")
        #expect(throws: RevisionError.unreadable(ENOENT))
        {
            try Revision.of(missing)
        }
    }
}
