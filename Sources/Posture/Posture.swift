import Foundation

package struct Posture: Hashable, Sendable
{
    package enum Placement: String, Codable, Sendable
    {
        case bare
        case housed
    }

    package static let bundleIdentifier = "manuscript.posture-probe"

    package let name: String
    package let placement: Placement
    package let signing: Signing?

    package init(name: String, placement: Placement, signing: Signing?)
    {
        self.name = name
        self.placement = placement
        self.signing = signing
    }

    package static let unsigned = Posture(
        name: "unsigned",
        placement: .bare,
        signing: nil)

    package static func adhocBare(_ entitlements: Entitlements) -> Posture
    {
        Posture(
            name: "adhoc-bare",
            placement: .bare,
            signing: Signing(
                identifier: bundleIdentifier + ".bare",
                entitlements: entitlements))
    }

    package static func adhocHoused(_ entitlements: Entitlements) -> Posture
    {
        Posture(
            name: "adhoc-housed",
            placement: .housed,
            signing: Signing(entitlements: entitlements))
    }

    package static func developer(
        _ identity: String,
        _ entitlements: Entitlements,
        hardened: Bool) -> Posture
    {
        Posture(
            name: hardened ? "developer-hardened" : "developer",
            placement: .housed,
            signing: Signing(
                identity: .named(identity),
                entitlements: entitlements,
                hardened: hardened))
    }

    package func stand(
        _ executable: URL,
        helpers: [URL] = [],
        in scratch: URL) throws -> URL
    {
        let column = scratch.appendingPathComponent(name)
        try? FileManager.default.removeItem(at: column)
        try FileManager.default.createDirectory(
            at: column,
            withIntermediateDirectories: true)
        let name = executable.lastPathComponent
        let copy = column.appendingPathComponent(name)
        try FileManager.default.copyItem(at: executable, to: copy)
        let target: URL
        let runnable: URL
        switch placement
        {
        case .bare:
            for helper in helpers
            {
                try FileManager.default.copyItem(
                    at: helper,
                    to: column.appendingPathComponent(helper.lastPathComponent))
            }
            target = copy
            runnable = copy
        case .housed:
            let housing = Housing(
                identifier: Self.bundleIdentifier,
                executable: name)
            target = try housing.assemble(
                around: copy,
                helpers: helpers,
                in: column)
            runnable = target
                .appendingPathComponent("Contents/MacOS")
                .appendingPathComponent(name)
        }
        if let signing
        {
            let receipt = try signing.apply(to: target, scratch: column)
            guard receipt.status == 0 else
            {
                throw Signing.Refusal(receipt: receipt)
            }
        }
        return runnable
    }
}
