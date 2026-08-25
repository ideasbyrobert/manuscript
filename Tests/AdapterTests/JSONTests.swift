import Foundation
import Testing

@testable import Adapter

@Suite("A JSON value that survives a round trip")
struct JSONTests
{
    @Test("literals build a document and it comes back the same")
    func roundTrip() throws
    {
        let document: JSON =
        [
            "name": "x",
            "count": 3,
            "ratio": 0.5,
            "on": true,
            "none": nil,
            "items": [1, "two", [3]]
        ]
        let data = try JSONEncoder().encode(document)
        let back = try JSONDecoder().decode(JSON.self, from: data)
        #expect(back == document)
    }

    @Test("a one is a number and a true is a bool, never each other")
    func numbersAndBoolsStayApart() throws
    {
        let one = try JSONDecoder().decode(JSON.self, from: Data("1".utf8))
        let yes = try JSONDecoder().decode(JSON.self, from: Data("true".utf8))
        #expect(one == .number(1))
        #expect(one.bool == nil)
        #expect(yes == .bool(true))
        #expect(yes.int == nil)
    }

    @Test("accessors answer only for their own case")
    func accessors()
    {
        let document: JSON = ["n": 2.0, "s": "text", "a": [1], "f": 2.5]
        #expect(document["n"]?.int == 2)
        #expect(document["f"]?.int == nil)
        #expect(document["s"]?.string == "text")
        #expect(document["a"]?.array == [.number(1)])
        #expect(document["missing"] == nil)
        #expect(JSON.string("x")["key"] == nil)
    }
}
