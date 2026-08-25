package struct Entitlements: Hashable, Sendable
{
    package struct Key: Hashable, Sendable
    {
        package let name: String

        private static let prefix = "com.apple.security."

        package static let appSandbox = Key(name: prefix + "app-sandbox")
        package static let networkClient =
            Key(name: prefix + "network.client")
        package static let bookmarksAppScope =
            Key(name: prefix + "files.bookmarks.app-scope")
        package static let userSelectedReadOnly =
            Key(name: prefix + "files.user-selected.read-only")
        package static let getTaskAllow =
            Key(name: prefix + "get-task-allow")
        package static let machRegisterGlobal =
            Key(name: prefix + "temporary-exception.mach-register.global-name")
    }

    package let entries: [Key: Plist.Value]

    package init(_ entries: [Key: Plist.Value])
    {
        self.entries = entries
    }

    package static let sandboxed = Entitlements(
        [.appSandbox: .flag(true), .getTaskAllow: .flag(true)])

    package func adding(
        _ key: Key,
        _ value: Plist.Value = .flag(true)) -> Entitlements
    {
        var entries = entries
        entries[key] = value
        return Entitlements(entries)
    }

    package func dropping(_ key: Key) -> Entitlements
    {
        var entries = entries
        entries.removeValue(forKey: key)
        return Entitlements(entries)
    }

    package var text: String
    {
        Plist.document(
            Dictionary(uniqueKeysWithValues: entries.map { ($0.name, $1) }))
    }
}
