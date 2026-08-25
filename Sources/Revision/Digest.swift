import CryptoKit
import Foundation

package struct Digest: Hashable, Sendable
{
    package let hex: String

    package init(of data: Data)
    {
        var hasher = SHA256()
        hasher.update(data: data)
        hex = Self.hex(hasher.finalize())
    }

    private init(hex: String)
    {
        self.hex = hex
    }

    package static func of(contentsOf url: URL) throws -> Digest
    {
        let handle = try FileHandle(forReadingFrom: url)
        defer
        {
            try? handle.close()
        }
        var hasher = SHA256()
        while let piece = try handle.read(upToCount: 64 * 1_024),
            !piece.isEmpty
        {
            hasher.update(data: piece)
        }
        return Digest(hex: hex(hasher.finalize()))
    }

    private static func hex(_ digest: SHA256.Digest) -> String
    {
        digest.map { String(format: "%02x", $0) }.joined()
    }
}
