import Testing

@testable import Adapter

@Suite("Three ways a link can refuse")
struct AdapterErrorTests
{
    @Test("the cases are distinct")
    func distinct()
    {
        let all: Set<AdapterError> = [.ended, .notStarted, .corruptStream]
        #expect(all.count == 3)
    }
}
