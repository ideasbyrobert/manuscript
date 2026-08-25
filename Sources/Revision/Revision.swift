import Darwin
import Foundation

package struct Revision: Hashable, Sendable
{
    package let device: Int32
    package let inode: UInt64
    package let size: Int64
    package let modified: Instant
    package let changed: Instant
    package let digest: Digest?

    package static func of(_ url: URL) throws -> Revision
    {
        try of(url, on: Volume.of(url))
    }

    package static func of(_ url: URL, on volume: Volume) throws -> Revision
    {
        var info = stat()
        guard fstatat(AT_FDCWD, url.path, &info, 0) == 0 else
        {
            throw RevisionError.unreadable(errno)
        }
        let digest = try volume.keepsChangeTime
            ? nil
            : Digest.of(contentsOf: url)
        return Revision(
            device: info.st_dev,
            inode: info.st_ino,
            size: info.st_size,
            modified: Instant(info.st_mtimespec),
            changed: Instant(info.st_ctimespec),
            digest: digest)
    }
}
