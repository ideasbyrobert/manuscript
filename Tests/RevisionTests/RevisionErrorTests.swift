import Testing

@testable import Revision

@Suite("What a revision can refuse to say")
struct RevisionErrorTests
{
    @Test("too large carries the least count that was seen")
    func tooLargeCarriesCount()
    {
        let nine = RevisionError.tooLarge(minimumObserved: 9)
        #expect(nine == .tooLarge(minimumObserved: 9))
        #expect(nine != .tooLarge(minimumObserved: 8))
        #expect(nine != .invalidMaximum)
    }

    @Test("unreadable carries the errno")
    func unreadableCarriesErrno()
    {
        #expect(RevisionError.unreadable(2) != .unreadable(13))
    }
}
