import Foundation
import Testing

@testable import Posture

@Suite("One column of the matrix, stood up in scratch", .serialized)
struct PostureTests
{
    @Test("standing a column copies the build and never signs it in place")
    func neverInPlace() throws
    {
        let fixture = try Fixture()
        defer
        {
            fixture.remove()
        }
        let built = try #require(Products.postureProbe)
        let before = try Data(contentsOf: built)
        let stood = try Posture.adhocBare(.sandboxed)
            .stand(built, in: fixture.scratch)
        #expect(stood.path.hasPrefix(fixture.scratch.path))
        #expect(try Data(contentsOf: built) == before)
        let signed = try Signing.entitlements(of: stood)
        #expect(signed["com.apple.security.app-sandbox"] as? Bool == true)
    }

    @Test("a housed column runs from inside its own application")
    func housedRunsFromTheBundle() throws
    {
        let fixture = try Fixture()
        defer
        {
            fixture.remove()
        }
        let built = try #require(Products.postureProbe)
        let stood = try Posture.adhocHoused(.sandboxed)
            .stand(built, in: fixture.scratch)
        #expect(stood.path.contains(".app/Contents/MacOS/"))
        let bundle = stood.deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        let identifier = Bundle(url: bundle)?.bundleIdentifier
        #expect(identifier == Posture.bundleIdentifier)
    }

    @Test("a refusal by codesign is thrown with its words")
    func refusalIsThrown() throws
    {
        let fixture = try Fixture()
        defer
        {
            fixture.remove()
        }
        let built = try #require(Products.postureProbe)
        let bad = Posture(
            name: "bad",
            placement: .bare,
            signing: Signing(identity: .named("No Such Identity")))
        #expect(throws: Signing.Refusal.self)
        {
            try bad.stand(built, in: fixture.scratch)
        }
    }
}
