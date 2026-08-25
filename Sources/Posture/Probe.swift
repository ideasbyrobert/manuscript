import Foundation
package enum Probe: String, CaseIterable, Codable, Sendable
{
    case sandbox
    case read
    case bookmark
    case web
    case debug
    case mach
    case machClient = "mach-client"

    package var entitlements: Entitlements
    {
        switch self
        {
        case .bookmark: return .sandboxed.adding(.bookmarksAppScope)
        case .web: return .sandboxed.adding(.networkClient)
        default: return .sandboxed
        }
    }

    package func measure(_ arguments: [String]) async -> Report
    {
        let facts = Container.facts
        switch self
        {
        case .sandbox:
            let paths = ["outside": arguments.first ?? ""]
            return Report(self, verdicts: Outside.measure(paths), facts: facts)
        case .read:
            let paths =
            [
                "documents": arguments.first ?? "",
                "argv": arguments.dropFirst().first ?? ""
            ]
            return Report(self, verdicts: Outside.measure(paths), facts: facts)
        case .bookmark:
            let path = Bookmark.path(arguments.first ?? "")
            return Report(self, verdicts: Bookmark.measure(path), facts: facts)
        case .web:
            let address = arguments.first ?? ""
            let verdicts = await Page.measure(address, within: .seconds(60))
            return Report(self, verdicts: verdicts, facts: facts)
        case .debug:
            let adapter = arguments.first ?? ""
            let program = arguments.dropFirst().first ?? ""
            let verdicts = await Debugger.measure(
                adapter: adapter,
                program: program)
            return Report(self, verdicts: verdicts, facts: facts)
        case .mach, .machClient:
            let bundle = Bundle.main.bundleIdentifier
            return Report(
                self,
                verdicts: Rendezvous.measure(bundleID: bundle),
                facts: facts)
        }
    }
}
