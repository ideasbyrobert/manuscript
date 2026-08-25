import Darwin
import Foundation
import Testing

@testable import Revision

@Suite("Which volumes keep a change time")
struct VolumeTests
{
    @Test("this machine's temporary directory is APFS")
    func temporaryIsAPFS() throws
    {
        let scratch = try Scratch()
        defer
        {
            scratch.remove()
        }
        #expect(try Volume.of(scratch.directory) == .apfs)
    }

    @Test("only APFS is trusted with a change time")
    func trust()
    {
        #expect(Volume.apfs.keepsChangeTime)
        #expect(!Volume.other("exfat").keepsChangeTime)
        #expect(!Volume.other("hfs").keepsChangeTime)
        #expect(!Volume.other("msdos").keepsChangeTime)
    }

    @Test("a path that is not there answers with the kernel's errno")
    func missingPath()
    {
        let missing = URL(fileURLWithPath: "/nowhere/at/all")
        #expect(throws: RevisionError.unreadable(ENOENT))
        {
            try Volume.of(missing)
        }
    }
}
