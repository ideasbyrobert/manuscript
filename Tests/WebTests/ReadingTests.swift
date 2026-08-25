import Foundation
import Testing

@testable import Web

@Suite("The seven numbers, carried back as one value")
struct ReadingTests
{
    @Test("a reading survives JSON with its counts intact")
    func roundTrip() throws
    {
        let reading = Reading(
            blocks: 3,
            grounded: 2,
            ungrounded: 1,
            spans: 4,
            under: 0,
            worst: 3.19,
            collateral: 0,
            orphan: 1,
            siteDark: false,
            weDark: false)
        let data = try JSONEncoder().encode(reading)
        let back = try JSONDecoder().decode(Reading.self, from: data)
        #expect(back == reading)
    }
}
