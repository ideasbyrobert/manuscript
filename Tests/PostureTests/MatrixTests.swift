import Darwin
import Foundation
import Testing

@testable import Posture

@Suite("The kernel's answers, one posture at a time", .serialized)
struct MatrixTests
{
    private func stood(
        _ posture: Posture,
        in fixture: Fixture) throws -> URL
    {
        let built = try #require(Products.postureProbe)
        return try posture.stand(built, in: fixture.scratch)
    }

    private func outside(
        _ posture: Posture,
        in fixture: Fixture) async throws -> Report
    {
        let probe = try stood(posture, in: fixture)
        return try await Run.probe(probe, .sandbox, [fixture.outside.path])
    }

    @Test("unsigned, the build reads the file beside home")
    func unsignedControl() async throws
    {
        let fixture = try Fixture()
        defer
        {
            fixture.remove()
        }
        let report = try await outside(.unsigned, in: fixture)
        #expect(report["outside"]?.answer == .permitted, "\(report.json)")
        #expect(report.facts["contained"] == "false")
    }

    @Test("bare and ad-hoc, the sandbox will not start the process: SIGTRAP")
    func adhocBareCannotStart() async throws
    {
        let fixture = try Fixture()
        defer
        {
            fixture.remove()
        }
        let posture = Posture.adhocBare(Probe.sandbox.entitlements)
        let report = try await outside(posture, in: fixture)
        #expect(report["outside"] == nil, "\(report.json)")
        #expect(report["launch"]?.answer == .failed)
        #expect(report["launch"]?.code == Int(SIGTRAP))
        #expect(report["launch"]?.message == "signal")
        let bare = Posture.bundleIdentifier + ".bare"
        let container = URL(fileURLWithPath: NSHomeDirectory())
            .appendingPathComponent("Library/Containers")
            .appendingPathComponent(bare)
        #expect(!FileManager.default.fileExists(atPath: container.path))
    }

    @Test("the housed identifier on a bare binary does not start it either")
    func identifierIsNotABundle() async throws
    {
        let fixture = try Fixture()
        defer
        {
            fixture.remove()
        }
        let named = Posture(
            name: "adhoc-bare-named",
            placement: .bare,
            signing: Signing(
                identifier: Posture.bundleIdentifier,
                entitlements: Probe.sandbox.entitlements))
        let report = try await outside(named, in: fixture)
        #expect(report["outside"] == nil, "\(report.json)")
        #expect(report["launch"]?.code == Int(SIGTRAP))
    }

    @Test("housed and ad-hoc, the file beside home is refused with EPERM")
    func adhocHoused() async throws
    {
        let fixture = try Fixture()
        defer
        {
            fixture.remove()
        }
        let posture = Posture.adhocHoused(Probe.sandbox.entitlements)
        let report = try await outside(posture, in: fixture)
        #expect(report["outside"]?.answer == .denied, "\(report.json)")
        #expect(report["outside"]?.errno == EPERM)
        #expect(report.facts["contained"] == "true", "\(report.facts)")
        #expect(report.facts["bundle"] == Posture.bundleIdentifier)
    }

    @Test("without app-sandbox the same signature reads it")
    func withoutTheEntitlement() async throws
    {
        let fixture = try Fixture()
        defer
        {
            fixture.remove()
        }
        let free = Entitlements.sandboxed.dropping(.appSandbox)
        for posture in [Posture.adhocBare(free), .adhocHoused(free)]
        {
            let report = try await outside(posture, in: fixture)
            #expect(report["outside"]?.answer == .permitted, "\(report.json)")
            #expect(report.facts["contained"] == "false", "\(posture.name)")
        }
    }

    @Test("a path on the command line is no grant")
    func argvIsNoGrant() async throws
    {
        let fixture = try Fixture()
        defer
        {
            fixture.remove()
        }
        let documents = try #require(fixture.documents)
        let probe = try stood(.adhocHoused(.sandboxed), in: fixture)
        let report = try await Run.probe(
            probe,
            .read,
            [documents.path, fixture.argv.path])
        #expect(report["argv"]?.answer == .denied, "\(report.json)")
        #expect(report["argv"]?.errno == EPERM)
        #expect(report["documents"]?.answer == .denied)
        #expect(report["documents"]?.errno == EPERM)
    }
}
