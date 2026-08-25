import Foundation
import Testing

@testable import Revision

@Suite("A file read without trusting its size")
struct BoundedReadTests
{
    @Test("nine bytes are refused by a limit of eight, and counted")
    func nineAgainstEight() throws
    {
        let scratch = try Scratch()
        defer
        {
            scratch.remove()
        }
        let url = try scratch.file("nine", holding: "123456789")
        #expect(throws: RevisionError.tooLarge(minimumObserved: 9))
        {
            try BoundedRead.read(at: url, maximumBytes: 8)
        }
    }

    @Test("a file exactly at the limit is admitted whole")
    func exactlyAtTheLimit() throws
    {
        let scratch = try Scratch()
        defer
        {
            scratch.remove()
        }
        let url = try scratch.file("eight", holding: "12345678")
        let found = try BoundedRead.read(at: url, maximumBytes: 8)
        #expect(found == Data("12345678".utf8))
    }

    @Test("a file that grows after reading begins is refused")
    func growsAfterReadingBegins() throws
    {
        let scratch = try Scratch()
        defer
        {
            scratch.remove()
        }
        let url = try scratch.file("grows", holding: "1234")
        var calls = 0
        #expect(throws: RevisionError.tooLarge(minimumObserved: 9))
        {
            try BoundedRead.read(at: url, maximumBytes: 8)
            {
                calls += 1
                guard calls == 2 else
                {
                    return
                }
                let handle = try FileHandle(forWritingTo: url)
                try handle.seekToEnd()
                try handle.write(contentsOf: Data("56789".utf8))
                try handle.close()
            }
        }
    }

    @Test("a negative limit is refused before the file is opened")
    func negativeLimit()
    {
        let nowhere = URL(fileURLWithPath: "/nowhere")
        #expect(throws: RevisionError.invalidMaximum)
        {
            try BoundedRead.read(at: nowhere, maximumBytes: -1)
        }
    }
}
