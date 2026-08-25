import Foundation

package struct Housing: Hashable, Sendable
{
    package let identifier: String
    package let executable: String

    package init(identifier: String, executable: String)
    {
        self.identifier = identifier
        self.executable = executable
    }

    package var infoPlist: String
    {
        Plist.document(
        [
            "CFBundleIdentifier": .text(identifier),
            "CFBundleExecutable": .text(executable),
            "CFBundleName": .text(executable),
            "CFBundlePackageType": .text("APPL"),
            "CFBundleInfoDictionaryVersion": .text("6.0"),
            "CFBundleVersion": .text("1"),
            "CFBundleShortVersionString": .text("1.0"),
            "LSMinimumSystemVersion": .text("15.0"),
            "LSUIElement": .flag(true)
        ])
    }

    package func assemble(
        around binary: URL,
        helpers: [URL] = [],
        in directory: URL) throws -> URL
    {
        let bundle = directory.appendingPathComponent(executable + ".app")
        let contents = bundle.appendingPathComponent("Contents")
        let macOS = contents.appendingPathComponent("MacOS")
        try FileManager.default.createDirectory(
            at: macOS,
            withIntermediateDirectories: true)
        try Data(infoPlist.utf8).write(
            to: contents.appendingPathComponent("Info.plist"))
        try FileManager.default.copyItem(
            at: binary,
            to: macOS.appendingPathComponent(executable))
        for helper in helpers
        {
            try FileManager.default.copyItem(
                at: helper,
                to: macOS.appendingPathComponent(helper.lastPathComponent))
        }
        return bundle
    }
}
