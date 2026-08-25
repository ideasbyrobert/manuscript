import Foundation
import Testing

@testable import Posture

@Suite("codesign, invoked and read back", .serialized)
struct SigningTests
{
    @Test("the arguments name the identity, the file and the target")
    func arguments()
    {
        let signing = Signing(
            identifier: "manuscript.x",
            entitlements: .sandboxed)
        let found = signing.arguments(
            target: URL(fileURLWithPath: "/tmp/probe"),
            entitlementsFile: URL(fileURLWithPath: "/tmp/e.plist"))
        #expect(found == [
            "--force", "--sign", "-", "--timestamp=none",
            "--identifier", "manuscript.x",
            "--entitlements", "/tmp/e.plist", "/tmp/probe"
        ])
        let named = Signing(
            identity: .named("Apple Development"),
            hardened: true)
        let hardened = named.arguments(
            target: URL(fileURLWithPath: "/tmp/probe"),
            entitlementsFile: nil)
        #expect(hardened.contains("--options"))
        #expect(hardened.contains("--timestamp"))
        #expect(!hardened.contains("--entitlements"))
    }

    @Test("a signed copy carries the rendered keys and none of the build's")
    func signedCopyCarriesOnlyTheRendered() throws
    {
        let fixture = try Fixture()
        defer
        {
            fixture.remove()
        }
        let built = try #require(Products.postureProbe)
        let before = try Signing.entitlements(of: built)
        #expect(before["com.apple.security.get-task-allow"] as? Bool == true)
        let copy = fixture.scratch.appendingPathComponent("copy")
        try FileManager.default.copyItem(at: built, to: copy)
        let signing = Signing(
            entitlements: .sandboxed.dropping(.getTaskAllow))
        let receipt = try signing.apply(to: copy, scratch: fixture.scratch)
        #expect(receipt.status == 0, "\(receipt.stderr)")
        let after = try Signing.entitlements(of: copy)
        #expect(after["com.apple.security.app-sandbox"] as? Bool == true)
        #expect(after["com.apple.security.get-task-allow"] == nil)
        let untouched = try Signing.entitlements(of: built)
        #expect(untouched["com.apple.security.app-sandbox"] == nil)
    }

    @Test("codesign refuses a file that is not a plist, and says so")
    func refusalIsReturned() throws
    {
        let fixture = try Fixture()
        defer
        {
            fixture.remove()
        }
        let built = try #require(Products.postureProbe)
        let copy = fixture.scratch.appendingPathComponent("copy")
        try FileManager.default.copyItem(at: built, to: copy)
        let garbage = fixture.scratch.appendingPathComponent("garbage")
        try Data("not a plist".utf8).write(to: garbage)
        let receipt = try Signing().apply(to: copy, entitlementsFile: garbage)
        #expect(receipt.status != 0)
        #expect(!receipt.stderr.isEmpty)
    }
}
