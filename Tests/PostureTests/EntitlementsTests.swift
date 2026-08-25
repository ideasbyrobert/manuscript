import Foundation
import Testing

@testable import Posture

@Suite("Entitlements as a value")
struct EntitlementsTests
{
    @Test("the sandboxed preset asks for the sandbox and stays debuggable")
    func sandboxedPreset() throws
    {
        let text = Entitlements.sandboxed.text
        let parsed = try PropertyListSerialization.propertyList(
            from: Data(text.utf8),
            format: nil) as? [String: Any]
        #expect(parsed?["com.apple.security.app-sandbox"] as? Bool == true)
        #expect(parsed?["com.apple.security.get-task-allow"] as? Bool == true)
        #expect(parsed?.count == 2)
    }

    @Test("dropping a key leaves no trace of it in the text")
    func droppingLeavesNoTrace()
    {
        let without = Entitlements.sandboxed.dropping(.appSandbox)
        #expect(!without.text.contains("app-sandbox"))
        #expect(without.text.contains("get-task-allow"))
        #expect(Entitlements.sandboxed.text.contains("app-sandbox"))
    }

    @Test("adding a list renders an array under the full Apple key")
    func addingAList() throws
    {
        let with = Entitlements.sandboxed
            .adding(.machRegisterGlobal, .list(["manuscript.probe"]))
        let parsed = try PropertyListSerialization.propertyList(
            from: Data(with.text.utf8),
            format: nil) as? [String: Any]
        let key = "com.apple.security.temporary-exception"
            + ".mach-register.global-name"
        #expect(parsed?[key] as? [String] == ["manuscript.probe"])
    }
}
