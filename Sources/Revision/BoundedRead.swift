import Foundation

package enum BoundedRead
{
    static let piece = 64 * 1_024

    package static func read(
        at url: URL,
        maximumBytes: Int,
        between: () throws -> Void = {}) throws -> Data
    {
        guard maximumBytes >= 0 else
        {
            throw RevisionError.invalidMaximum
        }
        let handle = try FileHandle(forReadingFrom: url)
        defer
        {
            try? handle.close()
        }
        var data = Data()
        data.reserveCapacity(min(maximumBytes, Self.piece))
        while true
        {
            try between()
            let remaining = maximumBytes - data.count
            let allowance = remaining == Int.max ? Int.max : remaining + 1
            guard let found = try handle.read(
                upToCount: min(Self.piece, allowance)),
                !found.isEmpty else
            {
                return data
            }
            guard found.count <= remaining else
            {
                throw RevisionError.tooLarge(
                    minimumObserved: data.count + found.count)
            }
            data.append(found)
        }
    }
}
