import Foundation

package struct Signing: Hashable, Sendable
{
    package enum Identity: Hashable, Sendable
    {
        case adhoc
        case named(String)
    }

    package struct Receipt: Hashable, Sendable
    {
        package let status: Int32
        package let stderr: String
    }

    package struct Refusal: Error, Hashable, Sendable
    {
        package let receipt: Receipt
    }

    package let identity: Identity
    package let identifier: String?
    package let entitlements: Entitlements?
    package let hardened: Bool

    package init(
        identity: Identity = .adhoc,
        identifier: String? = nil,
        entitlements: Entitlements? = nil,
        hardened: Bool = false)
    {
        self.identity = identity
        self.identifier = identifier
        self.entitlements = entitlements
        self.hardened = hardened
    }

    package func arguments(target: URL, entitlementsFile: URL?) -> [String]
    {
        var arguments = ["--force"]
        switch identity
        {
        case .adhoc:
            arguments += ["--sign", "-", "--timestamp=none"]
        case .named(let name):
            arguments += ["--sign", name, "--timestamp"]
        }
        if hardened
        {
            arguments += ["--options", "runtime"]
        }
        if let identifier
        {
            arguments += ["--identifier", identifier]
        }
        if let entitlementsFile
        {
            arguments += ["--entitlements", entitlementsFile.path]
        }
        arguments.append(target.path)
        return arguments
    }

    package func apply(to target: URL, scratch: URL) throws -> Receipt
    {
        var file: URL?
        if let entitlements
        {
            let written = scratch.appendingPathComponent("signing.entitlements")
            try Data(entitlements.text.utf8).write(to: written)
            file = written
        }
        return try apply(to: target, entitlementsFile: file)
    }

    package func apply(to target: URL, entitlementsFile: URL?) throws -> Receipt
    {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/codesign")
        process.arguments = arguments(
            target: target,
            entitlementsFile: entitlementsFile)
        let errors = Pipe()
        process.standardError = errors
        process.standardOutput = Pipe()
        try process.run()
        let stderr = errors.fileHandleForReading.readDataToEndOfFile()
        process.waitUntilExit()
        return Receipt(
            status: process.terminationStatus,
            stderr: String(decoding: stderr, as: UTF8.self))
    }

    package static func entitlements(of binary: URL) throws -> [String: Any]
    {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/codesign")
        process.arguments = ["-d", "--entitlements", "-", "--xml", binary.path]
        let output = Pipe()
        process.standardOutput = output
        process.standardError = Pipe()
        try process.run()
        let data = output.fileHandleForReading.readDataToEndOfFile()
        process.waitUntilExit()
        guard !data.isEmpty else
        {
            return [:]
        }
        let parsed = try PropertyListSerialization.propertyList(
            from: data,
            format: nil)
        return parsed as? [String: Any] ?? [:]
    }
}
