import Foundation

package struct Bracket: Sendable
{
    package let before: Revision
    package let bytes: Data
    package let after: Revision?

    package var isTorn: Bool
    {
        after != before
    }

    package static func read(
        at url: URL,
        maximumBytes: Int,
        between: () throws -> Void = {}) throws -> Bracket
    {
        let before = try Revision.of(url)
        let bytes = try BoundedRead.read(
            at: url,
            maximumBytes: maximumBytes,
            between: between)
        return Bracket(
            before: before,
            bytes: bytes,
            after: try? Revision.of(url))
    }
}
