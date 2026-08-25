import Darwin
import Foundation

package enum Volume: Hashable, Sendable
{
    case apfs
    case other(String)

    package static func of(_ url: URL) throws -> Volume
    {
        let descriptor = open(url.path, O_RDONLY)
        guard descriptor >= 0 else
        {
            throw RevisionError.unreadable(errno)
        }
        defer
        {
            close(descriptor)
        }
        var info = statfs()
        guard fstatfs(descriptor, &info) == 0 else
        {
            throw RevisionError.unreadable(errno)
        }
        let name = withUnsafePointer(to: &info.f_fstypename)
        {
            $0.withMemoryRebound(to: CChar.self, capacity: 16)
            {
                String(cString: $0)
            }
        }
        return name == "apfs" ? .apfs : .other(name)
    }

    package var keepsChangeTime: Bool
    {
        self == .apfs
    }
}
