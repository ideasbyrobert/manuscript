import Darwin

package struct Instant: Hashable, Comparable, Sendable
{
    package let seconds: Int64
    package let nanoseconds: Int64

    package init(seconds: Int64, nanoseconds: Int64)
    {
        self.seconds = seconds
        self.nanoseconds = nanoseconds
    }

    init(_ time: timespec)
    {
        self.init(
            seconds: Int64(time.tv_sec),
            nanoseconds: Int64(time.tv_nsec))
    }

    package static func < (one: Instant, other: Instant) -> Bool
    {
        (one.seconds, one.nanoseconds) < (other.seconds, other.nanoseconds)
    }
}
