import Foundation
import Testing

@testable import Posture

@Suite("A property list written, never hand-edited")
struct PlistTests
{
    @Test("a rendered document parses back to the same keys and values")
    func roundTrip() throws
    {
        let text = Plist.document(
        [
            "flag": .flag(true),
            "off": .flag(false),
            "name": .text("manuscript"),
            "names": .list(["a", "b"])
        ])
        let parsed = try PropertyListSerialization.propertyList(
            from: Data(text.utf8),
            format: nil)
        let dictionary = try #require(parsed as? [String: Any])
        #expect(dictionary["flag"] as? Bool == true)
        #expect(dictionary["off"] as? Bool == false)
        #expect(dictionary["name"] as? String == "manuscript")
        #expect(dictionary["names"] as? [String] == ["a", "b"])
        #expect(dictionary.count == 4)
    }

    @Test("keys are written in sorted order, so two renders compare equal")
    func sortedKeys()
    {
        let one = Plist.document(["b": .flag(true), "a": .flag(true)])
        let two = Plist.document(["a": .flag(true), "b": .flag(true)])
        #expect(one == two)
        let a = try! #require(one.range(of: "<key>a</key>")).lowerBound
        let b = try! #require(one.range(of: "<key>b</key>")).lowerBound
        #expect(a < b)
    }

    @Test("markup in a value is escaped, not injected")
    func escaped() throws
    {
        let text = Plist.document(["k": .text("a<b>&\"c\"")])
        #expect(text.contains("<string>a&lt;b&gt;&amp;&quot;c&quot;</string>"))
        let parsed = try PropertyListSerialization.propertyList(
            from: Data(text.utf8),
            format: nil) as? [String: Any]
        #expect(parsed?["k"] as? String == "a<b>&\"c\"")
    }
}
