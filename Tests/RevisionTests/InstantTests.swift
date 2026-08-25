import Darwin
import Testing

@testable import Revision

@Suite("Seconds first, then nanoseconds")
struct InstantTests
{
    @Test("a later second wins over more nanoseconds")
    func secondsFirst()
    {
        let early = Instant(seconds: 1, nanoseconds: 999_999_999)
        let late = Instant(seconds: 2, nanoseconds: 0)
        #expect(early < late)
        #expect(!(late < early))
    }

    @Test("within a second, nanoseconds order")
    func nanosecondsWithin()
    {
        let one = Instant(seconds: 5, nanoseconds: 10)
        let two = Instant(seconds: 5, nanoseconds: 11)
        #expect(one < two)
        #expect(one != two)
        #expect(one == Instant(seconds: 5, nanoseconds: 10))
    }

    @Test("it is read straight from a timespec")
    func fromTimespec()
    {
        let time = timespec(tv_sec: 7, tv_nsec: 42)
        #expect(Instant(time) == Instant(seconds: 7, nanoseconds: 42))
    }
}
